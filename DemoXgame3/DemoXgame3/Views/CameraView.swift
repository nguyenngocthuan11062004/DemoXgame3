//
//  CameraView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 4/11/25.
//
import SwiftUI
import AVFoundation
import Vision
import UIKit

// MARK: - SwiftUI View
struct CameraView: View {
    @StateObject private var vm = HeadTiltModel()

    var body: some View {
        ZStack {
            CameraPreview(model: vm)
                .edgesIgnoringSafeArea(.all)

            GeometryReader { geo in
                ZStack {
                    Image("balloon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120 * vm.leftScale,
                               height: 120 * vm.leftScale)
                        .position(x: geo.size.width * 0.2,
                                  y: geo.size.height * 0.35)
                        .animation(.easeOut(duration: 0.12), value: vm.leftScale)

                    Image("balloon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120 * vm.rightScale,
                               height: 120 * vm.rightScale)
                        .position(x: geo.size.width * 0.8,
                                  y: geo.size.height * 0.35)
                        .animation(.easeOut(duration: 0.12), value: vm.rightScale)

                    if vm.showSticker {
                        let img = UIImage(named: "catmim")
                        let aspect = img.map { $0.size.height / max($0.size.width, 1) } ?? 1.0

                        let widthPts  = geo.size.width * vm.stickerWidthFrac
                        let heightPts = widthPts * aspect

                        let bottomX = geo.size.width  * vm.stickerX
                        let bottomY = geo.size.height * vm.stickerY

                        let centerX = bottomX
                        let centerY = bottomY - heightPts / 2.0

                        Image("catmim")
                            .resizable()
                            .scaledToFit()
                            .frame(width: widthPts)
                            .rotationEffect(.radians(vm.stickerAngleRad), anchor: .bottom)
                            .position(x: centerX, y: centerY)
                            .animation(.easeOut(duration: 0.10), value: vm.stickerX)
                            .animation(.easeOut(duration: 0.10), value: vm.stickerY)
                            .animation(.easeOut(duration: 0.10), value: vm.stickerWidthFrac)
                            .animation(.easeOut(duration: 0.10), value: vm.stickerAngleRad)
                    }
                }
            }
            .allowsHitTesting(false)
        }
        .onAppear { vm.startTicker() }
        .onDisappear { vm.stopTicker() }
    }
}

// MARK: - Bridge SwiftUI ↔ UIKit
struct CameraPreview: UIViewControllerRepresentable {
    let model: HeadTiltModel

    func makeUIViewController(context: Context) -> PreviewController {
        let vc = PreviewController()
        vc.model = model
        vc.setupSession()
        return vc
    }
    func updateUIViewController(_ uiViewController: PreviewController, context: Context) {}
}

// MARK: - Controller: Camera + Vision
final class PreviewController: UIViewController {
    weak var model: HeadTiltModel?

    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let visionQueue = DispatchQueue(label: "vision.queue")
    private let requestHandler = VNSequenceRequestHandler()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var lastVisionTime = CFAbsoluteTimeGetCurrent()

    private var neutralRoll: Double? = nil
    private var calibSum: Double = 0
    private var calibCount: Int = 0
    private let calibNeeded: Int = 12
    private var tSmoothed: CGFloat = 0

    private let acceptRad: Double = 0.17

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        session.addInput(input)

        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }
        videoOutput.setSampleBufferDelegate(self, queue: visionQueue)

        if let conn = videoOutput.connection(with: .video) {
            conn.videoOrientation = .portrait
            conn.isVideoMirrored = true
        }

        session.commitConfiguration()

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }

    private func resetCalibration() {
        neutralRoll = nil
        calibSum = 0
        calibCount = 0
        tSmoothed = 0
        DispatchQueue.main.async {
            self.model?.targetLeft  = 1
            self.model?.targetRight = 1
            self.model?.showSticker = false
        }
    }

    private func applyRoll(_ roll: Double?) {
        guard let r = roll else {
            DispatchQueue.main.async {
                self.model?.targetLeft  = 1
                self.model?.targetRight = 1
            }
            return
        }

        let neutral = neutralRoll ?? 0.0

        let delta = r - neutral
        let limit = 0.52
        let clamped = max(min(delta, limit), -limit)
        var t = clamped / limit

        let deadZone: CGFloat = 0.06
        if abs(CGFloat(t)) < deadZone { t = 0 }

        let alpha: CGFloat = 0.30
        tSmoothed = (1 - alpha) * tSmoothed + alpha * CGFloat(t)

        let base: CGFloat = 1.0
        let amp:  CGFloat = 0.45
        let minS: CGFloat = 0.8, maxS: CGFloat = 1.5

        let leftTarget  = min(max(base + amp * max(0, -tSmoothed), minS), maxS)
        let rightTarget = min(max(base + amp * max(0,  tSmoothed), minS), maxS)

        DispatchQueue.main.async {
            self.model?.targetLeft  = leftTarget
            self.model?.targetRight = rightTarget
        }
    }
    // MARK: - Sticker helpers
    private func absPoint(in face: VNFaceObservation, from p: CGPoint) -> CGPoint {
        let bb = face.boundingBox
        return CGPoint(x: bb.origin.x + p.x * bb.size.width,
                       y: bb.origin.y + p.y * bb.size.height)
    }

    private func avg(_ region: VNFaceLandmarkRegion2D) -> CGPoint {
        let n = Int(region.pointCount)
        guard n > 0 else { return .zero }
        var sx: CGFloat = 0, sy: CGFloat = 0
        for i in 0..<n {
            let p = region.normalizedPoints[i]
            sx += CGFloat(p.x)
            sy += CGFloat(p.y)
        }
        return CGPoint(x: sx / CGFloat(n), y: sy / CGFloat(n))
    }

    private func updateSticker(with face: VNFaceObservation) {
        guard let landmarks = face.landmarks,
              let leftEye = landmarks.leftEye,
              let rightEye = landmarks.rightEye else {
            DispatchQueue.main.async { self.model?.showSticker = false }
            return
        }

        let leB = avg(leftEye)
        let reB = avg(rightEye)

        let le = absPoint(in: face, from: leB)
        let re = absPoint(in: face, from: reB)

        let eyeCenter = CGPoint(x: (le.x + re.x) * 0.5, y: (le.y + re.y) * 0.5)
        let interEye  = hypot(re.x - le.x, re.y - le.y)

        let dx = re.x - le.x
        let dy = re.y - le.y
        let raw = atan2(-dy, dx)
        let base = (model?.invertStickerRotation == true) ? -raw : raw
        let bias = model?.stickerAngleBias ?? 0
        let angleForSwiftUI = base + bias

        let bb = face.boundingBox
        let yTopAbs = bb.maxY
        let aboveFactor: CGFloat = 0.25
        let foreheadYAbs = min(yTopAbs + aboveFactor * bb.height, 1.0)
        let foreheadXAbs = eyeCenter.x

        let stickerX = foreheadXAbs
        let stickerY = 1.0 - foreheadYAbs

        let widthFrac = min(max(interEye * 1.8, 0.08), 0.6)

        DispatchQueue.main.async {
            self.model?.showSticker = true
            self.model?.stickerX = CGFloat(stickerX)
            self.model?.stickerY = CGFloat(stickerY)
            self.model?.stickerWidthFrac = CGFloat(widthFrac)
            self.model?.stickerAngleRad = CGFloat(angleForSwiftUI)
        }
    }
}
// MARK: - Capture delegate
extension PreviewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        let now = CFAbsoluteTimeGetCurrent()
        if now - lastVisionTime < (1.0 / 30.0) { return }
        lastVisionTime = now

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let faceRequest = VNDetectFaceLandmarksRequest { [weak self] req, _ in
            guard let self = self else { return }
            let face = (req.results as? [VNFaceObservation])?.first
            let roll = face?.roll?.doubleValue

            if self.neutralRoll == nil, let r = roll, abs(r) < self.acceptRad {
                self.calibSum   += r
                self.calibCount += 1
                if self.calibCount >= self.calibNeeded {
                    self.neutralRoll = self.calibSum / Double(self.calibCount)
                }
            }

            if let face {
                self.applyRoll(roll)
                self.updateSticker(with: face)

                if let neutral = self.neutralRoll, let r = roll {
                    let smallMove = 0.02
                    let beta: Double = 0.01
                    if abs(r - neutral) < smallMove {
                        self.neutralRoll = neutral * (1 - beta) + r * beta
                    }
                }
            } else {
                self.resetCalibration()
            }
        }

        let visionOrientation: CGImagePropertyOrientation = connection.isVideoMirrored ? .upMirrored : .up
        do {
            try requestHandler.perform([faceRequest], on: pixelBuffer, orientation: visionOrientation)
        } catch {
            resetCalibration()
        }
    }
}

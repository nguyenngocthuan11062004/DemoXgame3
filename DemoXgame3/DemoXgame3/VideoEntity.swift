//
//  VideoEntity.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 30/10/25.
//

import Foundation
import RealmSwift

class VideoEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var background: String = ""
    @Persisted var hashtag: String = ""
    @Persisted var likes: Int = 0

    convenience init(background: String, hashtag: String, likes: Int) {
        self.init()
        self.background = background
        self.hashtag = hashtag
        self.likes = likes
    }
}

class FilterEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var name: String = ""
    @Persisted var isSelected: Bool = false
    @Persisted var useCount: Int = 0

    convenience init(name: String, isSelected: Bool = true, useCount: Int = 1) {
        self.init()
        self.name = name
        self.isSelected = isSelected
        self.useCount = useCount
    }
}

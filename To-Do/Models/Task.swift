//
//  Task.swift
//  To-Do
//
//  Created by Jasin ‎ on 11/1/24.
//

import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var dueDate: Date?
    var dueTime: Date?
    var isCompleted: Bool
    var category: String?
    var description: String

    init(id: UUID = UUID(), title: String, dueDate: Date? = nil, dueTime: Date? = nil, isCompleted: Bool = false, category: String? = nil, description: String) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.isCompleted = isCompleted
        self.category = category
        self.description = description
    }
}

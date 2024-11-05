//
//  TaskViewModel.swift
//  To-Do
//
//  Created by Jasin ‎ on 11/1/24.
//

import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var categories: [String] = []
    
    init() {
        loadTasks()
        loadCategories()
    }
    
    func addTask(title: String, dueDate: Date?, dueTime: Date?, category: String?, description: String) {
        let newTask = Task(
            title: title,
            dueDate: dueDate,
            dueTime: dueTime,
            category: category,
            description: description
        )
        
        DispatchQueue.main.async {
            self.tasks.append(newTask)
            self.saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            saveTasks()
        }
    }
    
    private func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }
    
    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            tasks = decodedTasks
        }
    }
    
    func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "categories")
    }
    
    private func loadCategories() {
        if let savedCategories = UserDefaults.standard.stringArray(forKey: "categories") {
            categories = savedCategories
        }
    }
}

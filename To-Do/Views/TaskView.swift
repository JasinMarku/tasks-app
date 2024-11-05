//
//  TaskView.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/18/24.
//

import SwiftUI
import Combine

struct TaskView: View {
    @Binding var tasks: [Task]
    @Binding var categories: [String]
    @State private var newTask: String = ""
    @State private var dueDate: Date = Date()
    @State private var dueTime: Date = Date()
    @State private var isDatePickerVisible = false
    @State private var isTaskDescriptionVisable = false
    @State private var selectedCategory: String?
    @State private var newCategory: String = ""
    @State private var isAddingNewCategory = false
    @State private var trigger = false
    @FocusState private var isFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var debouncedTask = ""
    @State private var taskDescription = ""
    @State private var debounceTask: AnyCancellable?
    @State private var includeTime = false
    @State private var isManagingCategories = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(Color.appMainBackground).ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .foregroundStyle(Color.appAccentTwo)
                            }
                            Spacer()
                            Text("Create a Task")
                                .font(.title2)
                                .fontWeight(.medium)
                            Spacer()
                            Spacer()
                        }
                        .padding(.top, 30)


                        VStack(alignment: .leading, spacing: 30) {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Task")
                                    .foregroundStyle(.primary.opacity(0.7))
                                    .fontWeight(.medium)
                                
                                TextField("Enter Task", text: $newTask)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding()
                                    .background(.gray.opacity(0.13), in: RoundedRectangle(cornerRadius: 15))
                                    .onChange(of: newTask) {
                                        debounceTask?.cancel()
                                        debounceTask = Just(newTask)
                                            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
                                            .sink { value in
                                                self.debouncedTask = value
                                            }
                                    }
                                    .focused($isFocused)
                                    .keyboardType(.default)
                            }

                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Category")
                                    .foregroundStyle(.primary.opacity(0.7))
                                    .fontWeight(.medium)
                                
                                Button(action: {
                                    isManagingCategories = true
                                    trigger.toggle()
                                }) {
                                    HStack {
                                        Text(selectedCategory ?? "Select Category")
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                    }
                                    .sensoryFeedback(
                                               .impact(weight: .heavy, intensity: 0.9),
                                               trigger: trigger
                                           )
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.gray.opacity(0.13))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .foregroundStyle(selectedCategory != nil ? Color.appAccentOne.opacity(0.7) : .secondary.opacity(0.6))
                                }
                                .tint(.primary)
                                .sheet(isPresented: $isManagingCategories) {
                                    ManageCategoriesView(categories: $categories, selectedCategory: $selectedCategory, isPresented: $isManagingCategories)
                                        .presentationDetents([.height(550)])
                                        .presentationCornerRadius(30)
                                        .presentationBackground(Color.appMainBackground)

                            }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Due Date")
                                    .foregroundStyle(.primary.opacity(0.7))
                                    .fontWeight(.medium)
                                Button(action: {
                                    withAnimation {
                                        isDatePickerVisible.toggle()
                                    }
                                    isFocused = false
                                    trigger.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                        Divider()
                                        DateFormattedView(dueDate: dueDate, dueTime: includeTime ? dueTime : nil)
                                    }
                                    .sensoryFeedback(
                                               .impact(weight: .heavy, intensity: 0.9),
                                               trigger: trigger
                                           )
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.gray.opacity(0.13), in: RoundedRectangle(cornerRadius: 15))
                                    .foregroundStyle(isDatePickerVisible ? Color.appAccentOne : .secondary)
                                }
                            .tint(.primary)
                            }
                            
                            
                            
                            if isDatePickerVisible {
                                VStack(alignment: .leading) {
                                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                                        .datePickerStyle(.compact)
                                        .frame(maxHeight: 330)
                                    
                                    Toggle("Include Time", isOn: $includeTime)
                                    
                                    if includeTime {
                                        DatePicker("Due Time", selection: $dueTime, displayedComponents: .hourAndMinute)
                                            .datePickerStyle(.compact)
                                            .frame(maxHeight: 100)
                                    }
                                }
                                .padding(.bottom, -20)
                                .padding(.top, -20)
                                .padding()
                                .transition(.opacity.combined(with: .scale))
                                .tint(.appAccentOne)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 9) {
                                Button(action: {
                                    withAnimation {
                                        isTaskDescriptionVisable.toggle()
                                    }
                                }, label: {
                                    HStack(alignment: .center) {
                                        Text("Add Description")
                                            .foregroundStyle(isTaskDescriptionVisable ? Color.appAccentOne : .primary.opacity(0.7))
                                                .fontWeight(.medium)
                                    }
                                    .foregroundStyle(.primary.opacity(0.7))
                                    .fontWeight(.medium)
                                })
                                .tint(.primary)

                                
                                
                                if isTaskDescriptionVisable {
                                    TextField("Enter Description", text: $taskDescription, axis: .vertical)
                                        .lineLimit(5...10)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding()
                                        .background(.gray.opacity(0.13), in: RoundedRectangle(cornerRadius: 15))
                                        .focused($isFocused)
                                        .keyboardType(.default)
                                }
                            }
                            
                            Button(action: {
                                if !debouncedTask.isEmpty {
                                    addTask()
                                    trigger.toggle()
                                }
                            }) {
                                Text("Add Task")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(colors: [.appAccentOne, .appAccentTwo],
                                                       startPoint: .leading,
                                                       endPoint: .bottomTrailing))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .sensoryFeedback(
                                       .impact(weight: .heavy, intensity: 0.9),
                                       trigger: trigger
                                   )
                            
                            Spacer(minLength: 50)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .fontDesign(.rounded)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func addTask() {
        DispatchQueue.global(qos: .userInitiated).async {
            let newTask = Task(
                title: debouncedTask,
                dueDate: dueDate,
                dueTime: includeTime ? dueTime : nil,
                category: selectedCategory,
                description: taskDescription
            )
            DispatchQueue.main.async {
                tasks.append(newTask)
                saveTasks()
                saveCategories()
                self.newTask = ""
                self.debouncedTask = ""
                self.selectedCategory = nil
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }
    
    private func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "categories")
    }
    
    private func deleteTask(_ task: Task) {
           if let index = tasks.firstIndex(where: { $0.id == task.id }) {
               tasks.remove(at: index)
               saveTasks()
               saveCategories()
           }
       }
}

#Preview {
    TaskView(tasks: .constant([]), categories: .constant([]))
}

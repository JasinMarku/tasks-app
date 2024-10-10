//
//  ContentView.swift
//  To-Do
//
//  Created by Jasin  on 9/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var categories: [String] = []
    @AppStorage("userName") private var userName: String = ""
    @State private var showCustomizationView = false
    @State private var tempUserName: String = ""
    @State private var showClearConfirmation = false
    @State private var trigger = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.dismiss) private var dismiss
    
    private var completedTaskCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color(Color.appMainBackground).ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        VStack(alignment: .leading) {
                            
                            Text(userName.isEmpty ? "Hello!" : "Hello, \(userName)!")
                                .font(.system(size: 33))
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            
                                .tint(Color.primary)
                            Text(todayDateString)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .trailing) {
                                Text("\(Int(taskProgress * 100))%")
                                    .font(.subheadline)
                                    .foregroundColor(
                                        taskProgress == 0 ? .secondary :
                                            (taskProgress >= 1.0 ? Color.appAccentMint : Color.appAccentTwo))
                                    .fontWeight(.medium)
                                
                                ProgressView(value: taskProgress)
                                    .tint(taskProgress >= 1.0 ? Color.appAccentMint : Color.appAccentTwo)
                                    .scaleEffect(x: 1, y: 1.7, anchor: .center)
                                    .shadow(color: taskProgress == 0 ? Color.secondary.opacity(0.0) : (taskProgress >= 1.0 ? Color.appAccentMint : Color.appAccentTwo.opacity(0.9)), radius: 5, x: 0, y: 0)
                                
                                
                            }
                            .progressViewStyle(.linear)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        .zIndex(1)
                        
                        // Tasks list
                        ZStack {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text(tasks.count == 0 ? "No Tasks" : "\(completedTaskCount)/\(tasks.count) Tasks Completed")
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Button {
                                        sortTasksByDueDate()
                                        trigger.toggle()
                                    } label: {
                                        Text("Sort By Date")
                                            .frame(width: 100, height: 28)
                                            .background(Color.gray.opacity(0.2), in: Capsule())
                                            .foregroundStyle(Color.primary.opacity(0.5))
                                            .sensoryFeedback(
                                                .impact(weight: .heavy, intensity: 0.9),
                                                trigger: trigger
                                            )
                                    }
                                    
                                }
                                .fontWeight(.medium)
                                .font(.system(size: 13))
                                .opacity(0.7)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                                
                                if tasks.isEmpty {
                                    // Empty state view
                                    VStack(spacing: 10) {
                                        Image("leaf")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 160)
                                            .foregroundStyle(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .bottomTrailing))
                                        Text("Your task list is empty")
                                            .font(.system(size: 26))
                                            .foregroundColor(Color.primary.opacity(0.6))
                                            .fontDesign(.rounded)
                                            .fontWeight(.bold)
                                        
                                        Text("Start adding tasks below!")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.primary.opacity(0.6))
                                            .fontDesign(.rounded)
                                            .fontWeight(.medium)
                                    }
                                    .opacity(0.6)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    Spacer(minLength: 170)
                                } else {
                                    ScrollView {
                                        LazyVStack(spacing: 20) {
                                            ForEach($tasks) { $task in
                                                TaskRow(task: $task, toggleCompletion: toggleTaskCompletion, deleteTask: deleteTask)
                                            }
                                            .padding(.bottom, -2)
                                        }
                                        .padding(.bottom, 80)
                                    }
                                    .scrollIndicators(.hidden)
                                    .padding(.top, 5)
                                }
                            }
                            .padding(.horizontal)
                            
                            
                            VStack {
                                Spacer()
                                
                                NavigationLink {
                                    TaskView(tasks: $tasks, categories: $categories)
                                        .navigationBarBackButtonHidden(true)
                                        .onAppear { trigger.toggle() }
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .frame(width: 80, height: 80)
                                        .background(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .bottomTrailing))
                                        .clipShape(Circle())
                                        .multicolorGlow()
                                        .sensoryFeedback(
                                            .impact(weight: .heavy, intensity: 0.9),
                                            trigger: trigger
                                        )
                                }
                            }
                        }
                    }
                }
                
                .fontDesign(.rounded)
                .onAppear(perform: loadData)
                .onChange(of: tasks) {
                    saveTasks()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: CustomizationView(userName: $userName)
                            .navigationBarBackButtonHidden(true)
                            .onAppear { trigger.toggle() }
                        ) {
                            Image(systemName: "slider.vertical.3")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .fontWeight(.medium)
                                .sensoryFeedback(
                                    .impact(weight: .heavy, intensity: 0.9),
                                    trigger: trigger
                                )
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showClearConfirmation = true
                            trigger.toggle()
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 15))
                                .foregroundStyle(taskProgress >= 1.0 ? Color.appAccentTwo : Color.secondary)
                                .fontWeight(.medium)
                                .sensoryFeedback(
                                    .impact(weight: .heavy, intensity: 0.9),
                                    trigger: trigger
                                )
                        }
                        
                    }
                }
            }
        }
        
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear(perform: loadData)
        .sheet(isPresented: $showClearConfirmation) {
            ClearTasksPopup(onClear: {
                clearAllTasks()
                showClearConfirmation = false
            }, onCancel: {
                showClearConfirmation = false
            })
            .presentationDetents([.height(300)])
            .presentationCornerRadius(50)
            .presentationBackground(Color.appMainBackground.opacity(0.95))
        }
        //        .onAppear {
        //            if isFirstLaunch {
        //                tempUserName = "nil"
        //            }
        //        }
    }
    
    private func sortTasksByDueDate() {
        tasks.sort { task1, task2 in
            guard let date1 = task1.dueDate else { return false }
            guard let date2 = task2.dueDate else { return false }
            return date1 < date2
        }
        saveTasks()
    }
    
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            saveTasks()
        }
    }
    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: "tasks") {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
                tasks = decodedTasks
            }
        }
    }
    
    private func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        }
    }
    
    private func clearAllTasks() {
        tasks.removeAll()
        saveTasks()
    }
    
    private func loadCategories() {
        if let savedCategories = UserDefaults.standard.stringArray(forKey: "categories") {
            categories = savedCategories
        }
    }
    
    private func loadData() {
        loadTasks()
        loadCategories()
    }
    
    private var todayDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter.string(from: Date())
    }
    
    private var taskProgress: Double {
        guard !tasks.isEmpty else {
            return 0
        }
        let completedTasks = tasks.filter { $0.isCompleted }.count
        return Double(completedTasks) / Double(tasks.count)
    }

//    init() {
//        for familyName in UIFont.familyNames {
//            print(familyName)
//            
//            for fontName in UIFont.fontNames(forFamilyName: familyName) {
//                print("--- \(fontName)")
//            }
//        }
//    }
    
}


extension View {
    func multicolorGlow() -> some View {
        self.background(
            ZStack {
                ForEach(0..<2) { i in
                    Circle()
                        .stroke(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .bottomTrailing), lineWidth: 10)
                        .blur(radius: 10 + CGFloat(i * 4))
                        .opacity(0.4)
                }
            }
        )
    }
}

#Preview {
    ContentView()
}

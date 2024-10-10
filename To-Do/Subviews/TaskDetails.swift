//
//  TaskDetails.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/27/24.
//

import SwiftUI

extension UIApplication {
    /// Helper function to dismiss the keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TaskDetails: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    var deleteTask: (Task) -> Void
    @State private var trigger = false

    private var isTaskDueToday: Bool {
        guard let dueDate = task.dueDate else { return false }
        return Calendar.current.isDateInToday(dueDate)
    }
        
    var body: some View {
        
            ZStack {
                Color(Color.appMainBackground).ignoresSafeArea()
                    VStack(alignment: .leading) {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                                trigger.toggle()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .padding(.horizontal)
                                    .foregroundStyle(Color.appAccentOne)
                                    .padding(8)
                                    .background(.thinMaterial, in: Circle())
                                    .sensoryFeedback(
                                        .impact(weight: .heavy, intensity: 0.9),
                                        trigger: trigger
                                    )
                            }
                            
                            Spacer()
                            
                            Text(task.title)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                                .padding(.horizontal, 30)
                            
                            Spacer()
                            
                            Button(action: {
                                  deleteTask(task)
                                  presentationMode.wrappedValue.dismiss()
                                  trigger.toggle()
                            }, label: {
                                Image("trash")
                                    .renderingMode(.template)
                                    .padding(.horizontal)
                                    .foregroundStyle(Color.appAccentOne)
                                    .padding(7)
                                    .background(.thinMaterial, in: Circle())
                                    .sensoryFeedback(
                                        .impact(weight: .heavy, intensity: 0.9),
                                        trigger: trigger
                                    )
                            })
                        }
                        .padding(.top, 21)

                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 13) {
                                Text(task.isCompleted ? "Completed" : "In Progress")
                                    .font(.caption)
                                    .frame(width: 86, height: 30)
                                    .background(task.isCompleted ? Color.appAccentMint.opacity(0.5) : .secondary.opacity(0.3), in: Capsule())
                                    .foregroundStyle(.primary)
                                
                                Text("\(task.title)")
                                    .font(.system(size: 27))
                                    .fontWeight(.semibold)
                                
                                
                                // Task Category
                                if let category = task.category {
                                    Text(category)
                                        .fontWeight(.medium)
                                        .foregroundStyle(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .bottomTrailing))
                                } else {
                                    Text("General")
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                }
                                
                                VStack(spacing: 20) {
                                    // Date & Time Section
                                    HStack {
                                        VStack(alignment: .leading, spacing: 15) {
                                            Text("Due Date")
                                            
                                            Text("Time")
                                        }
                                        .foregroundStyle(.gray)
                                        .fontWeight(.medium)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading, spacing: 15) {
                                            HStack {
                                                Image("calendar")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 17)
                                                
                                                if let dueDate = task.dueDate {
                                                    if isTaskDueToday {
                                                        Text("Due Today")
                                                    } else {
                                                        Text(dueDate, style: .date)
                                                    }
                                                } else {
                                                    Text("No Date Set")
                                                }
                                            }
                                            
                                            
                                            HStack {
                                                Image("clock")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 17)
                                                
                                                if let dueTime = task.dueTime {
                                                    Text(dueTime, style: .time)
                                                } else {
                                                    Text("No Time Set")
                                                }
                                            }
                                        }
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 15))
                                        .fontWeight(.medium)
                                    }
                                }
                                .padding(.vertical, 10)
                                
                                // Description Section
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 5) {
                                        Text("Description")
                                            .fontWeight(.medium)
                                        
                                        
                                        Image("pencil")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                        
                                    }
                                    .foregroundStyle(.gray)

                                    
                                    TextEditor(text: $task.description)
                                        .padding(12) // Add padding inside the text editor
                                        .padding(.vertical, 1)
                                        .frame(height: 350) // Set the height of the text editor
                                        .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 15)) // Custom background
                                        .foregroundColor(.primary.opacity(0.5)) // Text color
                                        .scrollContentBackground(.hidden) // Hides the default white background of TextEditor (iOS 16+)/
                                        .scrollIndicators(.hidden)
                                    
                                }
                                
                            }
                        }
                                .padding()
                        Spacer()
                    }
                    .fontDesign(.rounded)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
            .tint(.primary)
    }
}

#Preview {
    TaskDetails(
        task: .constant(Task(
            id: UUID(),
            title: "Essay 2",
            isCompleted: true,
            category: "Terrorism & Homeland Security",
            description: ""
        )),
        deleteTask: { _ in }
    )
}


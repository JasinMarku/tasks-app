//
//  TaskDetails.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/27/24.
//

import SwiftUI

struct TaskDetails: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    var deleteTask: (Task) -> Void
        
    var body: some View {
        
        ZStack {
            Color(Color.appMainBackground).ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                            .foregroundStyle(Color.appAccentOne)
                    }
                    
                    Spacer()
                    
                    Text(task.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    Spacer()

                }
                .padding(.top, 21)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(task.isCompleted ? "Completed" : "In Progress")
                        .font(.caption)
                        .frame(width: 86, height: 30)
                        .background(task.isCompleted ? Color.appAccentMint.opacity(0.4) : .secondary.opacity(0.3), in: Capsule())
                        .foregroundStyle(.primary)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("\(task.title) details")
                            .font(.system(size: 27))
                            .fontWeight(.semibold)
                        
                        
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
                                            Text(dueDate, style: .date)
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

                        
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 5) {
                                    Text("Notes")
                                        .fontWeight(.medium)
                                    
                                    Image("pencil")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15)

                                }
                                .foregroundStyle(.gray)

                                ScrollView {
                                    TextField("Enter Notes", text: $task.description)
                                        .textFieldStyle(PlainTextFieldStyle())
//                                    if task.description.isEmpty {
//                                        Text("No notes taken for this task!")
//                                            .foregroundStyle(.gray.opacity(0.5))
//                                    } else {
//                                        Text(task.description)
//                                            .foregroundStyle(.gray)
//                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        deleteTask(task)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Delete Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .fontWeight(.bold)
                            .background(Color.appAccentOne, in: RoundedRectangle(cornerRadius: 15))
                            .foregroundStyle(Color.white)
                    })
                    
                }
                .padding()
                
                
                Spacer()
            }
            .fontDesign(.rounded)

        }
        
//        if let category = task.category {
//            Text(category)
//        } else {
//            Text("No Cateogry")
//        }
////        
//        if let dueDate = task.dueDate {
//            Text(dueDate, style: .date)
//        }
//        if let dueTime = task.dueTime {
//            Text(dueTime, style: .time)
//        }
    }
}

#Preview {
    TaskDetails(
        task: .constant(Task(
            id: UUID(),
            title: "Essay 2",
            isCompleted: true,
            category: "Terrorism & Homeland Security",
            description: "Sample Description Here"
        )),
        deleteTask: { _ in }
    )
}

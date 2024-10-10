//
//  TaskRow.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/20/24.
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


struct TaskRow: View {
    @Binding var task: Task
    let toggleCompletion: (Task) -> Void
    let deleteTask: (Task) -> Void
    @State private var isFlipping = false
    @State private var trigger = false

    
    private var isTaskDueToday: Bool {
        guard let dueDate = task.dueDate else { return false }
        return Calendar.current.isDateInToday(dueDate)
    }
    
    var body: some View {
        HStack(spacing: -10) {

            NavigationLink(destination:TaskDetails(task: $task, deleteTask: deleteTask)
                    .navigationBarBackButtonHidden(true)
                    .onAppear { trigger.toggle() }
            ) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title)
                            .font(.headline)
                            .strikethrough(task.isCompleted)
                        
                        if let category = task.category {
                            Text(category)
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundStyle(LinearGradient(colors: [task.isCompleted ? .gray : .appAccentOne, task.isCompleted ? .gray : .appAccentTwo], startPoint: .leading, endPoint: .bottomTrailing))
                        }
                        
                        if let dueDate = task.dueDate {
                            HStack(alignment: .center, spacing: 5) {
                                Image("calendar")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.secondary)
                                    .scaledToFit()
                                    .frame(width: 14)

                                
                                if isTaskDueToday {
                                    Text("Due Today")
                                } else {
                                    Text(dueDate, style: .date)
                                        .fontWeight(isTaskDueToday ? .medium : .regular)
                                }
                                if let dueTime = task.dueTime {
                                    Image("clock")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.secondary)
                                        .scaledToFit()
                                        .frame(width: 14)
                                    Text(dueTime, style: .time)
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                    }
                    .opacity(task.isCompleted ? 0.6 : 1)
                    Spacer()
                }
                .padding(.leading, 8)
                .tint(.primary)
            }
                
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isFlipping.toggle()
                    toggleCompletion(task)
                }
                trigger.toggle()
            }, label: {
                ZStack {
                    let check = Image(task.isCompleted ? "check-circle" : "circle")
                    
                    check
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(task.isCompleted ? Color.appAccentMint : Color.appAccentOne)
                }
                .rotation3DEffect(
                    .degrees(isFlipping ? 360 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
                .sensoryFeedback(.impact(weight: .heavy, intensity: 0.9), trigger: trigger)
                .padding(.trailing, 4)
            })
        }
        .sensoryFeedback(
                 .impact(weight: .heavy, intensity: 0.9),
                 trigger: trigger
             )
        .padding()
        .background(task.isCompleted ? Color.appAccentMint.opacity(0.15) : Color.appAccentTwo.opacity(0.15), in: RoundedRectangle(cornerRadius: 20))
        }
//        .padding()
//        .background(task.isCompleted ? Color.appAccentMint.opacity(0.15) : Color.appAccentTwo.opacity(0.15), in: RoundedRectangle(cornerRadius: 20))
    }


#Preview {
    TaskRow(
        task: .constant(Task(
            id: UUID(),
            title: "Sample Task",
            isCompleted: false,
            category: "Sample Category",
            description: "Sample Description"
        )),
        toggleCompletion: { _ in },
        deleteTask: { _ in }
    )
}


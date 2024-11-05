//
//  ClearTasksPopup.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/19/24.
//

import SwiftUI

import SwiftUI

struct ClearTasksPopup: View {
    var onClear: () -> Void
    var onCancel: () -> Void
    @State private var trigger = false

    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center) {
//                Text("Clear Tasks")
//                    .font(.title2)
//                    .fontWeight(.bold)
//
                Image("broom")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.appAccentOne)
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(.top, 2)
            }
            
            Text("Do you want to clear all tasks?")
                .font(.body)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                Button(action: {
                    onCancel()
                    trigger.toggle()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.primary)
                        .frame(width: 100)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        .sensoryFeedback(
                                   .impact(weight: .heavy, intensity: 0.9),
                                   trigger: trigger
                               )
                })
                
                Button(action: {
                    onClear()
                    trigger.toggle()
                }, label: {
                    Text("Clear")
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .padding()
                        .background(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                        .sensoryFeedback(
                                   .impact(weight: .heavy, intensity: 0.9),
                                   trigger: trigger
                               )
                })
//                Button(action: onClear, trigger.toggle()) {
//                    Text("Clear")
//                        .foregroundColor(.white)
//                        .frame(width: 100)
//                        .padding()
//                        .background(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .trailing))
//                        .clipShape(Capsule())
//                        .sensoryFeedback(
//                                   .impact(weight: .heavy, intensity: 0.9),
//                                   trigger: trigger
//                               )
//                }
            }
            .fontWeight(.medium)
            .shadow(radius: 15)

        }
        .padding(30)
    }
}

#Preview {
    ClearTasksPopup(onClear: {
        print("Clear tasks")
    }, onCancel: {
        print("Cancel clear tasks")
    })
}

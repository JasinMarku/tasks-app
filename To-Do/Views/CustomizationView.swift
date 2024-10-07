//
//  NamePromptView.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/19/24.
//

import SwiftUI

extension Color {
    static let appAccentOne = Color("Accent1")
    static let appAccentTwo = Color("Accent2")
    static let appAccentOrange = Color("myOrange")
    static let appAccentYellow = Color("myYellow")
    static let appAccentMint = Color("myMint")
    static let appAccentPink = Color("myPink")
    static let appAccentPurple = Color("myPurple")
    static let appMainBackground = Color("appBackground")
    static let appMainBackgroundTwo = Color("appBackgroundTwo")
}


public struct CustomizationView: View {
    @Binding var userName: String
    @Environment(\.presentationMode) var presentationMode
    @State private var inputName: String = ""
    @State private var isUserNameValid = false
    @State private var errorMessage = ""
    @AppStorage("isDarkMode") private var isDarkMode = false


    
    public var body: some View {
        ZStack {
            Color(Color.appMainBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    
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
                        Text("Customization")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                        Spacer()
                    }
                    .padding(.top, 21)
                    
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Name")
                            .foregroundStyle(.gray.opacity(0.7))
                            .fontWeight(.medium)
                        
                        TextField("Enter Name", text: $inputName)
                            .textFieldStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.gray.opacity(0.13), in: RoundedRectangle(cornerRadius: 15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onChange(of: inputName) {
                                validateUserName()
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Theme")
                            .foregroundStyle(.gray.opacity(0.7))
                            .fontWeight(.medium)
                        
                    Button(action: {
                        isDarkMode.toggle()
                    }, label: {
                        HStack {
                            Text(isDarkMode ? "Light Mode" : "Dark Mode")
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Image(isDarkMode ? "sun" : "moon")
                                .renderingMode(.template)
                                .foregroundStyle(Color.appAccentTwo)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appAccentOne.opacity(0.13), in: RoundedRectangle(cornerRadius: 15))
                    })
                }
                    .padding(.bottom)
                    
                    VStack(spacing: 30) {
                            Button(action: {
                                if isUserNameValid {
                                    userName = inputName
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }, label: {
                                Text("Confirm")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(isUserNameValid ? 1 : 0.6))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(colors: [.appAccentOne, .appAccentTwo],
                                                       startPoint: .leading,
                                                       endPoint: .bottomTrailing))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            })
                            .shadow(radius: 10)
                            .disabled(!isUserNameValid)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text(" ")
                        }
                    }
                }
                .tint(.secondary)
                .padding()
                .onAppear {
                    inputName = userName  // Initialize inputName with the current userName
                }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
    }
    
    private func validateUserName() {
        // Check length first
//        if inputName.isEmpty {
//            errorMessage = "Name cannot be empty!"
//            isUserNameValid = false
//        } else if inputName.count < 2 {
//            errorMessage = "Name must be at least 2 characters long."
//            isUserNameValid = false
//        } else 
        if inputName.count > 15 {
            errorMessage = "Name can't be longer than 15 characters."
            isUserNameValid = false
        } else {
            // Only check the regex if the length is valid
            let nameRegex = "^[a-zA-Z][a-zA-Z0-9_]{1,19}$"
            let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            isUserNameValid = namePredicate.evaluate(with: inputName)
            
            if !isUserNameValid {
                errorMessage = "Name must start with a letter and can only contain letters, numbers, and underscores."
            } else {
                errorMessage = "" // No errors
            }
        }
    }
}

#Preview {
    CustomizationView(userName: .constant(""))
}

//
//  ManageCategoriesView.swift
//  To-Do
//
//  Created by Jasin ‎ on 9/23/24.
//

import SwiftUI

struct ManageCategoriesView: View {
    @Binding var categories: [String]
    @Binding var selectedCategory: String?
    @Binding var isPresented: Bool
    @State private var newCategory: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Categories")
                .font(.title2)
                .fontWeight(.medium)
            
            TextField("New Category", text: $newCategory)
                .textFieldStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Button(action: {
                if !newCategory.isEmpty && !categories.contains(newCategory) {
                    categories.insert(newCategory, at: 0)
                    newCategory = ""
                }
            }, label: {
                Text("Add Category")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            })


            
            VStack(alignment: .leading) {
                
                Text("Added Categories")
                    .foregroundStyle(.primary.opacity(0.7))
                    .fontWeight(.medium)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                isPresented = false
                            }) {
                                Text(category)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .foregroundStyle(.primary)
                                    .background(Color.appAccentOne.opacity(0.5))
                                    .clipShape(Capsule())
                            }
                            .contextMenu {
                                Button(role: .destructive, action: {
                                    if let index = categories.firstIndex(of: category) {
                                        deleteCategory(at: IndexSet(integer: index))
                                    }
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .frame(height: 40)
            }
        }
        .fontDesign(.rounded)
        .padding()
        .tint(.primary)
    }

    private func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        if let selectedCategory = selectedCategory,
           !categories.contains(selectedCategory) {
            self.selectedCategory = nil
        }
    }
}

#Preview {
    ManageCategoriesView(categories: .constant(["Work","School","Gym","Personal","Appointment"]), selectedCategory: .constant(nil), isPresented: .constant(true))
}

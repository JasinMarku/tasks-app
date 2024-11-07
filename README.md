# To-Do App 📋

A feature-rich task management app built in **SwiftUI** with support for categorization, dark mode, due date sorting, and more. This project highlights core iOS development skills with an elegant, user-friendly interface.

## Technologies Used

- **SwiftUI**: For modern, declarative UI.
- **Combine**: To manage and bind UI updates.
- **UserDefaults**: For persistent local data storage.
- **MVVM Architecture**: Ensures clear separation of UI and business logic.

## Demo Video

https://github.com/user-attachments/assets/0dbe014b-ff92-4cbe-9d52-dd4aa1773a69

## Most Proud Of

### Problem
When adding or deleting categories in the `ManageCategoriesView`, changes were not saved if the user exited the app or reset the screen, leading to data inconsistency.

### Solution
This was fixed by updating the `deleteCategory` and `saveCategories` functions to directly save all changes to `UserDefaults`, ensuring all category updates were retained.

#### Key Code:
```swift
private func deleteCategory(at offsets: IndexSet) {
    categories.remove(atOffsets: offsets)
    if let selectedCategory = selectedCategory,
       !categories.contains(selectedCategory) {
        self.selectedCategory = nil
    }
    saveCategories() // Save the updated categories
}

private func saveCategories() {
    UserDefaults.standard.set(categories, forKey: "categories")
}
```

#### Usage in ManageCategoriesView:
```swift
// Delete category via context menu
.contextMenu {
    Button(role: .destructive) {
        if let index = categories.firstIndex(of: category) {
            deleteCategory(at: IndexSet(integer: index))
        }
    } label: {
        Label("Delete", systemImage: "trash")
    }
}

// Add new category
Button {
    if !newCategory.isEmpty && !categories.contains(newCategory) {
        categories.insert(newCategory, at: 0)
        newCategory = ""
        saveCategories() // Save new category
    }
} label: {
    Text("Add Category")
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(LinearGradient(colors: [.appAccentOne, .appAccentTwo], startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 15))
}
```

This approach ensures that all category modifications are saved instantly, providing a seamless experience for the user.

## Completeness

- **Task Creation**: Add tasks with titles, due dates, times, categories, and descriptions.
- **Task Categorization**: Organize tasks into custom categories for easy filtering and organization.
- **Due Date Sorting**: Sort tasks by their due date to prioritize upcoming tasks.
- **Task Editing**: Tap on any task to view, edit, or delete its details.
- **Progress Tracking**: Visual progress bar on the home screen shows completed tasks out of the total.
- **Dark Mode Support**: Full compatibility with dark mode for a comfortable viewing experience.
- **Clear All Tasks**: Single-tap option to clear all tasks with a confirmation prompt.
- **Data Persistence**: Tasks and categories are saved locally using `UserDefaults`, ensuring data is retained even after app restarts.
- **User Customization**: Customizable user greeting and personalization.
- **Smooth UX**: Sensory feedback and animations for a polished, responsive user experience.

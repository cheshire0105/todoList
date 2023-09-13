//
//  Model.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/28.
//

import Foundation
import CoreData

class TaskManager {
    static let shared = TaskManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Create
    func saveTask(taskTitle: String, isCompleted: Bool, categoryName: String) {
        let todo = Todo(context: context)
        todo.title = taskTitle
        todo.isCompleted = isCompleted
        
        // Find or create a category with the given name
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            let categories = try context.fetch(categoryFetchRequest)
            if let category = categories.first {
                // Category with the given name already exists
                todo.category = category
            } else {
                // Create a new category with the given name
                let newCategory = Category(context: context)
                newCategory.name = categoryName
                todo.category = newCategory
            }
            
            saveContext()
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    // Read
    func loadTasks() -> [[Todo]] {
        var tasks = [[Todo](), [Todo]()]
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let allTasks = try context.fetch(fetchRequest)
            for task in allTasks {
                if !task.isCompleted { // Only load tasks that are not completed
                    if let section = task.category?.name == "오전" ? 0 : 1 {
                        tasks[section].append(task)
                    }
                }
            }
        } catch {
            print("Error fetching tasks: \(error)")
        }
        
        return tasks
    }

    
    // Update
    func modifyTask(at indexPath: IndexPath, newTaskTitle: String, isCompleted: Bool) {
        let tasks = loadTasks()
        let task = tasks[indexPath.section][indexPath.row]
        task.title = newTaskTitle
        task.isCompleted = isCompleted
        saveContext()
    }
    
    // Delete
    func deleteTask(task: Todo) {
        context.delete(task)
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // Load completed tasks
    func loadCompletedTasks() -> [[Todo]] {
        var completedTasks = [[Todo](), [Todo]()]
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let allTasks = try context.fetch(fetchRequest)
            for task in allTasks {
                if task.isCompleted {
                    let section = task.category?.name == "오전" ? 0 : 1
                    completedTasks[section].append(task)
                }
            }
        } catch {
            print("Error fetching completed tasks: \(error)")
        }
        
        return completedTasks
    }

    // Revert a completed task to the task list
    func revertTaskToTodoList(task: Todo) {
        task.isCompleted = false
        saveContext()
    }

    // Delete a completed task
    func deleteCompletedTask(task: Todo) {
        context.delete(task)
        saveContext()
    }
    
    

}

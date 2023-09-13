//
//  Model.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/28.
//

import Foundation
import CoreData

// 할 일 관리자 클래스
class TaskManager {
    static let shared = TaskManager()
    
    // CoreData의 Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("해결되지 않은 오류 \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // CoreData에서 사용할 컨텍스트
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 할 일 추가 함수
    func saveTask(taskTitle: String, isCompleted: Bool, categoryName: String) {
        let todo = Todo(context: context)
        todo.title = taskTitle
        todo.isCompleted = isCompleted
        
        let category = Category(context: context)
        category.name = categoryName
        todo.category = category
        
        saveContext()
    }
    
    // 할 일 목록 불러오기 함수
    func loadTasks() -> [[Todo]] {
        var tasks = [[Todo](), [Todo]()]
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let allTasks = try context.fetch(fetchRequest)
            for task in allTasks {
                if !task.isCompleted { // 완료되지 않은 할 일만 로드
                    let section = task.category?.name == "오전" ? 0 : 1
                    tasks[section].append(task)
                }
            }
        } catch {
            print("할 일 목록 가져오기 오류: \(error)")
        }
        
        return tasks
    }
    
    // 할 일 수정 함수
    func modifyTask(at indexPath: IndexPath, newTaskTitle: String, isCompleted: Bool) {
        let tasks = loadTasks()
        
        guard indexPath.section < tasks.count,
              indexPath.row < tasks[indexPath.section].count else {
            print("인덱스 범위 초과 오류")
            return
        }
        
        let task = tasks[indexPath.section][indexPath.row]
        task.title = newTaskTitle
        task.isCompleted = isCompleted
        saveContext()
    }
  



    
    // 할 일 삭제 함수
    func deleteTask(task: Todo) {
        context.delete(task)
        saveContext()
    }
    
    // 변경사항 저장 함수
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("컨텍스트 저장 오류: \(error)")
            }
        }
    }
    
    // 완료된 할 일 목록 불러오기 함수
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
            print("완료된 할 일 목록 가져오기 오류: \(error)")
        }
        
        return completedTasks
    }
    
    // 완료된 할 일을 할 일 목록으로 되돌리는 함수
    func revertTaskToTodoList(task: Todo) {
        task.isCompleted = false
        saveContext()
    }
    
    // 완료된 할 일 삭제 함수
    func deleteCompletedTask(task: Todo) {
        context.delete(task)
        saveContext()
    }
    
    // 카테고리 수정 함수
    func modifyTaskCategory(task: Todo, newCategoryName: String) {
        let category = Category(context: context)
        category.name = newCategoryName
        task.category = category
        saveContext()
    }

}

//
//  Model.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/28.
//

import Foundation

class TaskManager {
    
    static let shared = TaskManager()
    
    private let tasksKey = "tasks"
    private let completedTasksKey = "completedTasks"
    
    private init() {}
    
    // MARK: - 해야 할 일
    func saveTask(task: String, inSection section: Int) {
        var tasks = UserDefaults.standard.array(forKey: tasksKey) as? [[String]] ?? [[String](), [String]()]
        
        // 배열의 크기를 검사하고 필요한 경우 적절한 크기로 확장합니다.
        while tasks.count <= section {
            tasks.append([String]())
        }
        
        tasks[section].append(task)
        UserDefaults.standard.set(tasks, forKey: tasksKey)
    }
    
    func loadTasks() -> [[String]] {
        return UserDefaults.standard.array(forKey: tasksKey) as? [[String]] ?? [[String](), [String]()]
    }
    
    func modifyTask(at index: Int, inSection section: Int, newTask: String) {
        var tasks = UserDefaults.standard.array(forKey: tasksKey) as? [[String]] ?? [[String](), [String]()]
        
        // 섹션 및 인덱스가 유효한 범위 내에 있는지 확인합니다.
        guard section < tasks.count, index < tasks[section].count else {
            return
        }
        
        tasks[section][index] = newTask
        UserDefaults.standard.set(tasks, forKey: tasksKey)
    }

    
    func deleteTask(at index: Int, inSection section: Int) {
        var tasks = UserDefaults.standard.array(forKey: tasksKey) as? [[String]] ?? [[String](), [String]()]
        
        // 섹션 및 인덱스가 유효한 범위 내에 있는지 확인합니다.
        guard section < tasks.count, index < tasks[section].count else {
            return
        }
        
        tasks[section].remove(at: index)
        UserDefaults.standard.set(tasks, forKey: tasksKey)
    }
    
    // MARK: - 완료 한 일
    func saveCompletedTask(task: String, inSection section: Int) {
        var completedTasks = UserDefaults.standard.array(forKey: completedTasksKey) as? [[String]] ?? [[String](), [String]()]
        
        // 배열의 크기를 검사하고 필요한 경우 적절한 크기로 확장합니다.
        while completedTasks.count <= section {
            completedTasks.append([String]())
        }
        
        completedTasks[section].append(task)
        UserDefaults.standard.set(completedTasks, forKey: completedTasksKey)
    }

    
    func loadCompletedTasks() -> [[String]] {
        let defaultTasks = [[String](), [String]()]
        guard let loadedTasks = UserDefaults.standard.array(forKey: completedTasksKey) as? [[String]] else {
            return defaultTasks
        }
        
        // 섹션의 크기를 검사하고 필요한 경우 적절한 크기로 확장합니다.
        var tasks = loadedTasks
        while tasks.count < defaultTasks.count {
            tasks.append([String]())
        }
        
        return tasks
    }
    
    func deleteCompletedTask(at index: Int, inSection section: Int) {
        var completedTasks = UserDefaults.standard.array(forKey: completedTasksKey) as? [[String]] ?? [[String](), [String]()]
        
        // 섹션 및 인덱스가 유효한 범위 내에 있는지 확인합니다.
        guard section < completedTasks.count, index < completedTasks[section].count else {
            return
        }
        
        completedTasks[section].remove(at: index)
        UserDefaults.standard.set(completedTasks, forKey: completedTasksKey)
    }
}


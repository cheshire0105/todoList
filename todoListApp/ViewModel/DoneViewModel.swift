//
//  DoneViewModel.swift
//  todoListApp
//
//  Created by cheshire on 2023/09/13.
//
import Foundation

class DonePageViewModel {
    var completedTasks = [[Todo](), [Todo]()]

    func loadAndUpdateCompletedTasks() {
        completedTasks = TaskManager.shared.loadCompletedTasks()
    }
    
    func revertTaskToTodoList(at indexPath: IndexPath) {
        let taskToRevert = completedTasks[indexPath.section][indexPath.row]
        completedTasks[indexPath.section].remove(at: indexPath.row)
        TaskManager.shared.revertTaskToTodoList(task: taskToRevert)
    }
    
    func deleteCompletedTask(at indexPath: IndexPath) {
        let taskToDelete = completedTasks[indexPath.section][indexPath.row]
        completedTasks[indexPath.section].remove(at: indexPath.row)
        TaskManager.shared.deleteCompletedTask(task: taskToDelete)
    }
}


import Foundation

class TodoPageViewModel {
    
    var tasks = [[Todo](), [Todo]()] // 할 일 배열을 오전과 오후로 나누어 저장
    
    // 데이터 로딩 메서드
    func loadAndUpdateTasks() {
        tasks = TaskManager.shared.loadTasks()
    }
    
    // 할 일 저장 메서드
    func saveTask(task: String, inSection section: Int) {
        TaskManager.shared.saveTask(taskTitle: task, isCompleted: false, categoryName: section == 0 ? "오전" : "오후")
        self.tasks = TaskManager.shared.loadTasks()
    }
    
    // 할 일 수정 메서드
    func modifyTask(at indexPath: IndexPath, with text: String, inSection section: Int) {
        let taskToMove = self.tasks[indexPath.section][indexPath.row]
        
        if section == indexPath.section {
            // 섹션이 변경되지 않았다면
            taskToMove.title = text
        } else {
            // 섹션이 변경되었다면
            self.tasks[indexPath.section].remove(at: indexPath.row)
            self.tasks[section].append(taskToMove) // 수정: Todo 인스턴스 추가
            
            // CoreData에서 카테고리 변경
            TaskManager.shared.modifyTaskCategory(task: taskToMove, newCategoryName: section == 0 ? "오전" : "오후")
        }
    }


    
    // 할 일 삭제 메서드
    func deleteTask(at indexPath: IndexPath) {
        TaskManager.shared.deleteTask(task: tasks[indexPath.section][indexPath.row])
        tasks[indexPath.section].remove(at: indexPath.row)
    }
    
    // 할 일 완료 상태 변경 메서드
    func completeTask(at indexPath: IndexPath) {
        var taskToToggle = tasks[indexPath.section][indexPath.row]
        taskToToggle.isCompleted.toggle()

        // CoreData에 변경 사항 저장
        if let taskTitle = taskToToggle.title {
            TaskManager.shared.modifyTask(at: indexPath, newTaskTitle: taskTitle, isCompleted: taskToToggle.isCompleted)
        }

        // 할 일 목록에서 삭제
        tasks[indexPath.section].remove(at: indexPath.row)
        TaskManager.shared.saveContext()
    }



}

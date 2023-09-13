import UIKit
import CoreData

class DonePage: UIViewController {
    // 완료된 작업을 2차원 배열로 변경. 첫 번째 배열은 오전, 두 번째 배열은 오후입니다.
    var completedTasks = [[Todo](), [Todo]()]
    
    @IBOutlet weak var doneTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
          // TaskManager에서 completedTasks 배열을 로드합니다.
          completedTasks = TaskManager.shared.loadCompletedTasks()
          
          // doneTableView의 dataSource와 delegate를 설정합니다.
          doneTableView.dataSource = self
          doneTableView.delegate = self
          
          // doneTableView를 리로드하여 로드된 작업 목록을 표시합니다.
          doneTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension DonePage: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2  // 오전과 오후 두 개의 섹션
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "오전" : "오후"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 다운 캐스팅 해서 레이블에 표시
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneCell", for: indexPath) as! DoneCell
        cell.doneLabel.text = completedTasks[indexPath.section][indexPath.row].title // 변경: .title 속성을 사용하여 문자열 얻기
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DonePage: UITableViewDelegate {
    // 셀이 선택되었을 때 호출되는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "할 일로 돌려보내기", message: "이 일을 할 일로 되돌려보낼까요?", preferredStyle: .alert)
        
        // 다시 할 일로 추가 버튼
        let revertAction = UIAlertAction(title: "추가", style: .default) { _ in
            let taskToRevert = self.completedTasks[indexPath.section][indexPath.row]
            self.completedTasks[indexPath.section].remove(at: indexPath.row)
            
            // saveTask 대신 revertTaskToTodoList 호출
            TaskManager.shared.revertTaskToTodoList(task: taskToRevert)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }


        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(revertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 밀어서 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = completedTasks[indexPath.section][indexPath.row]
            completedTasks[indexPath.section].remove(at: indexPath.row)
            TaskManager.shared.deleteCompletedTask(task: taskToDelete) // 불필요한 'inSection' 인수 제거
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }



}


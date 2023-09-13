import UIKit
import CoreData

class DonePageViewController: UIViewController {
    
    private var viewModel = DonePageViewModel()
    
    @IBOutlet weak var doneTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadAndUpdateCompletedTasks()
        
        doneTableView.dataSource = self
        doneTableView.delegate = self
        
        doneTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension DonePageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2  // 오전과 오후 두 개의 섹션
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "오전" : "오후"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.completedTasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneCell", for: indexPath) as! DoneCell
        cell.doneLabel.text = viewModel.completedTasks[indexPath.section][indexPath.row].title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DonePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "할 일로 되돌려보내기", message: "이 작업을 할 일 목록으로 되돌려보내시겠습니까?", preferredStyle: .alert)
        
        let revertAction = UIAlertAction(title: "되돌리기", style: .default) { _ in
            self.viewModel.revertTaskToTodoList(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(revertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCompletedTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

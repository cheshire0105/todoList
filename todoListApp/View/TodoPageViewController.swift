import UIKit
import CoreData

class TodoPageViewController: UIViewController {
    
    private var viewModel = TodoPageViewModel()
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
        // 오른쪽 상단에 할 일 추가 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // 뷰가 로드될 때 데이터 로드 및 초기화
        viewModel.loadAndUpdateTasks()
        todoTableView.reloadData()
        
        // 노티피케이션 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(switchToggled(notification:)), name: .switchToggled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 뷰가 나타날 때마다 데이터 다시 로드
        viewModel.loadAndUpdateTasks()
        todoTableView.reloadData()
        
        
    }
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "할 일 목록", message: "기억해야 할 일이 있나요?\n\n", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "여기에 할 일을 적어주세요"
        }
        
        // 시간 선택을 위한 세그먼트 컨트롤 추가
        let timeSelector = UISegmentedControl(items: ["오전", "오후"])
        timeSelector.selectedSegmentIndex = 0
        alertController.view.addSubview(timeSelector)
        
        // 세그먼트 컨트롤 위치 지정
        timeSelector.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeSelector.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 73),
            timeSelector.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor)
        ])
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { [unowned alertController] _ in
            if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                let section = timeSelector.selectedSegmentIndex // 0은 오전, 1은 오후
                self.viewModel.saveTask(task: text, inSection: section)
                self.todoTableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension TodoPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2  // 오전과 오후 두 개의 섹션
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "오전" : "오후"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoCell
        let todo = viewModel.tasks[indexPath.section][indexPath.row]
        cell.configure(with: todo)
        cell.indexPath = indexPath
        return cell
    }

}

// MARK: - UITableViewDelegate
extension TodoPageViewController: UITableViewDelegate {
    
    // 셀이 선택되었을 때 호출되는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "할 일 수정", message: "수정할 내용을 입력하세요\n\n", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "해야 할 일이 변경 되었나요?"
            textField.text = self.viewModel.tasks[indexPath.section][indexPath.row].title
        }
        
        // 시간 선택을 위한 세그먼트 컨트롤 추가
        let timeSelector = UISegmentedControl(items: ["오전", "오후"])
        timeSelector.selectedSegmentIndex = indexPath.section // 현재 선택된 섹션으로 설정
        alertController.view.addSubview(timeSelector)
        
        // 세그먼트 컨트롤 위치 지정
        timeSelector.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeSelector.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 73),
            timeSelector.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor)
        ])
        
        // 저장 버튼
        let saveAction = UIAlertAction(title: "저장", style: .default) { [unowned alertController] _ in
            if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                let section = timeSelector.selectedSegmentIndex // 선택된 세그먼트 인덱스
                self.viewModel.modifyTask(at: indexPath, with: text, inSection: section)
                tableView.reloadData()
            }
        }
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        // 셀 선택 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 셀 스와이프로 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - CellDelegate
extension TodoPageViewController {
    @objc func switchToggled(notification: Notification) {
        if let cell = notification.userInfo?["cell"] as? TodoCell, let indexPath = cell.indexPath {
            viewModel.completeTask(at: indexPath)

            DispatchQueue.main.async {
                self.todoTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }


}

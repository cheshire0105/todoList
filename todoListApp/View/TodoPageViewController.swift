import UIKit
import CoreData

class TodoPageViewController: UIViewController {
    
    var tasks = [[Todo](), [Todo]()]
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // viewDidLoad에서 데이터를 로드하고 초기화
        loadAndUpdateTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // viewWillAppear에서 데이터를 다시 로드
        loadAndUpdateTasks()
    }
    
    // 데이터를 로드하고 tasks 배열을 초기화한 후 테이블 뷰 리로드
    private func loadAndUpdateTasks() {
        // TaskManager에서 task 배열 로드
        tasks = TaskManager.shared.loadTasks()
        
        // 테이블 뷰를 리로드하여 로드된 task를 반영
        todoTableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "할 일 목록", message: "기억 해야 할 일이 있나요?\n\n", preferredStyle: .alert)
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
                self.saveTask(task: text, inSection: section)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveTask(task: String, inSection section: Int) {
        TaskManager.shared.saveTask(taskTitle: task, isCompleted: false, categoryName: section == 0 ? "오전" : "오후")
        self.tasks = TaskManager.shared.loadTasks()
        todoTableView.reloadData()
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
        return tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoCell
        cell.cellLabel.text = tasks[indexPath.section][indexPath.row].title
        cell.indexPath = indexPath
        cell.delegate = self
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
            textField.text = self.tasks[indexPath.section][indexPath.row].title
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
                TaskManager.shared.modifyTask(at: indexPath, newTaskTitle: text, isCompleted: false)
                
                if section == indexPath.section {
                    // 섹션이 변경되지 않았다면
                    self.tasks[indexPath.section][indexPath.row].title = text
                } else {
                    // 섹션이 변경되었다면
                    self.tasks[indexPath.section].remove(at: indexPath.row)
                    self.tasks[section].append(self.tasks[indexPath.section][indexPath.row]) // 수정: Todo 인스턴스 추가
                }
                
                tableView.reloadData()
            }
        }
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        // 셀 선택 해제
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TaskManager.shared.deleteTask(task: tasks[indexPath.section][indexPath.row])
            tasks[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - CellDelegate
extension TodoPageViewController: CellDelegate {
    func switchToggled(on cell: TodoCell) {
        guard let indexPath = cell.indexPath else {
            return
        }
        
        // 작업을 완료 상태로 변경
        if let taskTitle = tasks[indexPath.section][indexPath.row].title {
            TaskManager.shared.modifyTask(at: indexPath, newTaskTitle: taskTitle, isCompleted: true)
        }

        
        tasks[indexPath.section].remove(at: indexPath.row)
        todoTableView.deleteRows(at: [indexPath], with: .fade)

        
        // 변경 내용을 Core Data에 저장
        TaskManager.shared.saveContext()
        
        // 테이블 뷰 업데이트를 메인 스레드에서 비동기로 수행
        DispatchQueue.main.async {
            self.todoTableView.reloadData()
        }
    }
}




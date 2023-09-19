//
//  Cell.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/01.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var cellLabel: UILabel!
    
    var indexPath: IndexPath?

    func configure(with todo: Todo) {
            cellLabel.text = todo.title
        switchControl.isOn = todo.isCompleted // switchControl은 스위치의 IBOutlet이어야 합니다.
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cellButton(_ sender: UISwitch) {
        NotificationCenter.default.post(name: .switchToggled, object: nil, userInfo: ["cell": self])
    }
}

extension Notification.Name {
    static let switchToggled = Notification.Name("switchToggled")
}

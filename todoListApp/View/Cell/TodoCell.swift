//
//  Cell.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/01.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    var indexPath: IndexPath?
    
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

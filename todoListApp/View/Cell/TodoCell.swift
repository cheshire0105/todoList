//
//  Cell.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/01.
//

import UIKit

protocol CellDelegate: AnyObject {
    func switchToggled(on cell: TodoCell)
}

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    var indexPath: IndexPath?  // 셀의 인덱스를 저장하는 프로퍼티 추가
    
    //
    weak var delegate: CellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func cellButton(_ sender: UISwitch) {
        // 옵셔널 체이닝 문법
        // 스위치가 눌렸을 때 알려주는 것.
        delegate?.switchToggled(on: self)
        
    }
}

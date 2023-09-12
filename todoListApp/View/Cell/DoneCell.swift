//
//  DoneCell.swift
//  todoListApp
//
//  Created by cheshire on 2023/08/02.
//

import UIKit

class DoneCell: UITableViewCell {
    
    @IBOutlet weak var doneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
   
    
}

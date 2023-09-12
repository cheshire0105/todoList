//
//  ProfilePageViewController.swift
//  todoListApp
//
//  Created by cheshire on 2023/09/12.
//

import UIKit

class ProfilePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 배경색 설정
        
        // 뒤로 가기 버튼 생성
        let backButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 버튼을 뷰에 추가
        self.view.addSubview(backButton)
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

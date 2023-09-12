//
//  ProfileDesignViewController.swift
//  todoListApp
//
//  Created by cheshire on 2023/09/12.
//

import Foundation
import UIKit
import SnapKit

class ProfileDesignViewController: UIViewController {
    
    private let backButton: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "Profile") {
            imageView.image = image
        } else {
            imageView.backgroundColor = .gray
        }
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let customLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Bold", size: 18)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "nabaecamp", attributes: [NSAttributedString.Key.kern: -1])
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        
        
        return label
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "Menu") {
            button.setImage(image, for: .normal)
        } else {
            button.backgroundColor = .green // 이미지 로드 실패시 녹색 배경을 사용
        }
        return button
    }()
    
    
    private let userPicView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "UserPic") {
            imageView.image = image
        } else {
            imageView.backgroundColor = .gray // 이미지 로드 실패시 회색 배경을 사용
        }
        return imageView
    }()
    
    private let postsNum: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Bold", size: 16.5)
        label.textAlignment = .center
        label.text = "7"
        
        return label
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "post", attributes: [NSAttributedString.Key.kern: -0.3])
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let followersNum: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Bold", size: 16.5)
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private let followers: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "follower", attributes: [NSAttributedString.Key.kern: -0.3])
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let followingsNum: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Bold", size: 16.5)
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private let followings: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "following", attributes: [NSAttributedString.Key.kern: -0.3])
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let userInfoName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1)
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.attributedText = NSMutableAttributedString(string: "르탄이", attributes: [NSAttributedString.Key.kern: -0.5])
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 25)
        
        
        return label
    }()
    
    private let userInfoNickName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.attributedText = NSMutableAttributedString(string: "iOS Developer 🍎", attributes: [NSAttributedString.Key.kern: -0.5])
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let userInfoWeb: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.061, green: 0.274, blue: 0.492, alpha: 1)
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.attributedText = NSMutableAttributedString(string: "spartacodingclub.kr", attributes: [NSAttributedString.Key.kern: -0.5])
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let blueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.22, green: 0.596, blue: 0.953, alpha: 1)
        button.layer.cornerRadius = 4
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)  // 텍스트 색상을 흰색으로 설정합니다.
        
        return button
    }()
    
    private let whiteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1).cgColor
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.black, for: .normal)  // 텍스트 색상을 흰색으로 설정합니다.
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "More") {
            button.setImage(image, for: .normal)
        } else {
            button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 2)
        
        let stroke = UIView()
        stroke.bounds = view.bounds.insetBy(dx: -0.25, dy: -0.25)
        stroke.center = view.center
        view.addSubview(stroke)
        view.bounds = view.bounds.insetBy(dx: -0.25, dy: -0.25)
        stroke.layer.borderWidth = 0.5
        stroke.layer.borderColor = UIColor(red: 0.859, green: 0.859, blue: 0.859, alpha: 1).cgColor
        
        return view
    }()
    
    
    private let gridButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "Grid") {
            button.setImage(image, for: .normal)
        } else {
            button.backgroundColor = .gray // 이미지 로드 실패시 회색 배경을 사용
        }
        button.frame = CGRect(x: 0, y: 0, width: 22.5, height: 22.5)
        return button
    }()
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 2
        let numberOfItemsInRow: CGFloat = 3
        let totalPadding = padding * (numberOfItemsInRow - 1)
        
        let cellWidth = (screenWidth - totalPadding) / numberOfItemsInRow
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 상하좌우 패딩 없음
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 348).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        
        view.addSubview(customLabel)
        
        view.addSubview(menuButton)
        
        view.addSubview(userPicView)
        
        view.addSubview(postsNum)
        
        view.addSubview(postsLabel)
        
        view.addSubview(followersNum)
        
        view.addSubview(followers)
        
        view.addSubview(followingsNum)
        
        view.addSubview(followings)
        
        view.addSubview(userInfoName)
        
        view.addSubview(userInfoNickName)
        
        view.addSubview(userInfoWeb)
        
        view.addSubview(blueButton)
        
        view.addSubview(whiteButton)
        
        view.addSubview(moreButton)
        
        view.addSubview(line)
        
        view.addSubview(gridButton)
        
        
        
        
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBack))
        backButton.addGestureRecognizer(tapGesture)
        
        setupCollectionView()
        
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        
    }
    
    private func setupLayout() {
        backButton.snp.remakeConstraints { make in
            make.width.equalTo(22.5)
            make.height.equalTo(22.75)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        customLabel.snp.makeConstraints { make in
            make.width.equalTo(97)
            make.height.equalTo(28)
            make.leading.equalToSuperview().offset(139)
            make.top.equalToSuperview().offset(54)
        }
        
        menuButton.snp.makeConstraints { make in
            make.width.equalTo(21)
            make.height.equalTo(17.5)
            make.leading.equalToSuperview().offset(338)
            make.top.equalToSuperview().offset(58)
        }
        
        
        userPicView.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(88)
            make.leading.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(93)
        }
        
        postsNum.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.leading.equalToSuperview().offset(152)
            make.top.equalToSuperview().offset(116)
        }
        
        postsLabel.snp.makeConstraints { make in
            make.width.equalTo(28)
            make.height.equalTo(19)
            make.leading.equalToSuperview().offset(143)
            make.top.equalToSuperview().offset(138)
        }
        
        followersNum.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.leading.equalToSuperview().offset(232)
            make.top.equalToSuperview().offset(116)
        }
        
        followers.snp.makeConstraints { make in
            make.width.equalTo(51)
            make.height.equalTo(19)
            make.leading.equalToSuperview().offset(213)
            make.top.equalToSuperview().offset(138)
        }
        
        followingsNum.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.leading.equalToSuperview().offset(314)
            make.top.equalToSuperview().offset(116)
        }
        
        followings.snp.makeConstraints { make in
            make.width.equalTo(57)
            make.height.equalTo(19)
            make.leading.equalToSuperview().offset(290)
            make.top.equalToSuperview().offset(138)
        }
        
        userInfoName.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(19)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(195)
            
        }
        
        userInfoNickName.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(19)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(216)
        }
        
        userInfoWeb.snp.makeConstraints { make in
            make.width.equalTo(121)
            make.height.equalTo(19)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(235)
        }
        
        blueButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(265)
        }
        
        whiteButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(173)
            make.top.equalToSuperview().offset(265)
        }
        
        moreButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalToSuperview().offset(330)
            make.top.equalToSuperview().offset(265)
        }
        
        line.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
            make.top.equalTo(moreButton.snp.bottom).offset(10)
        }
        
        
        gridButton.snp.makeConstraints { make in
            make.width.equalTo(22.5)
            make.height.equalTo(22.5)
            make.leading.equalToSuperview().offset(52)
            make.top.equalToSuperview().offset(315)
        }
    }
    
    @objc private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func menuButtonTapped() {
        let profilePageVC = ProfilePageViewController()
        profilePageVC.modalPresentationStyle = .fullScreen // 전체 화면으로 보이게 설정
        self.present(profilePageVC, animated: true, completion: nil)
    }

    
    
}



extension ProfileDesignViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}


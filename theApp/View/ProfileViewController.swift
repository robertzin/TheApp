//
//  ProfileViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
       let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        iv.image = UIImage(named: "profilePhoto")
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private var nameLabel = PaddingLabel()
    
    private var emailLabel = PaddingLabel()
    
    private lazy var logOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Выйти"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        label.textColor = .red
        label.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(logOutLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        navigationItem.title = "Профиль"
        
        nameLabel = textLabel(text: "Robert")
        emailLabel = textLabel(text: "abc@gmail.com")
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(logOutLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(37)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(44)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(44)
        }
        
        logOutLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.width.equalToSuperview()
        }
    }
    
    private func textLabel(text: String) -> PaddingLabel {
        let label = PaddingLabel()
        label.text = text
        label.textColor = Constants.Colors.greyColor
        label.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        label.backgroundColor = Constants.Colors.textFieldColor
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.textAlignment = .left
        label.padding(0, 0, 10, 10)
        return label
    }
    
    @objc private func logOutLabelTapped() {
        Alert().presentTwoActionAlert(vc: self, title: "Выход", message: "Вы уверены, что хотите выйти из аккаунта?")
    }
}

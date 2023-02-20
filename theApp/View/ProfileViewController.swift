//
//  ProfileViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage()
        iv.layer.cornerRadius = 60
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var nameLabel = PaddingLabel()
    
    private var emailLabel = PaddingLabel()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var user: User?
    
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
        self.user = CoreDataManager.currentUser
        
        view.backgroundColor = Constants.Colors.backgroundColor
        navigationItem.title = "Профиль"
        
        nameLabel = textLabel(text: user?.name ?? "User")
        emailLabel = textLabel(text: user?.email ?? "lol@kek.com")
        
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(logOutLabel)
        
        activityIndicator.startAnimating()
        downloadImage(urlString: user?.imageUrl ?? "")
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.height.equalTo(120)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageView.snp.center)
            make.width.equalTo(140)
            make.height.equalTo(140)
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
    
    private func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.activityIndicator.stopAnimating()
            self.imageView.image = UIImage(named: "profilePhoto")!
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            if let data = data {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = UIImage(data: data)
                }
            } else {
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = UIImage(named: "profilePhoto")!
            }
        }).resume()
    }
    
    @objc private func logOutLabelTapped() {
        Alert().presentTwoActionAlert(vc: self, title: "Выход", message: "Вы уверены, что хотите выйти из аккаунта?")
    }
}

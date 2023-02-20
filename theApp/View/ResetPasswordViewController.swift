//
//  ResetPasswordViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//

import UIKit

final class ResetPasswordViewController: UIViewController {
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.size.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 20
        tf.placeholder = "name@mail.com"
        tf.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.tintColor = .red
        tf.textColor = Constants.Colors.darkGreyColor
        tf.backgroundColor = Constants.Colors.textFieldColor
        return tf
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors.buttonColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.setTitle("Сбросить пароль", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        button.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "SFProDisplay-Regular", size: 13)
        label.text = "Инструкция по сбросу пароля\nпридет Вам на почту"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Сброс пароля"
        
        view.addSubview(textField)
        view.addSubview(resetPasswordButton)
        view.addSubview(instructionLabel)
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(44)
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(resetPasswordButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func resetPasswordButtonTapped() {
        let email = textField.text ?? ""
        
        if email.isEmpty {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Заполните пустые поля")
        } else if email.isValidEmail() {
            Alert().presentAlert(vc: self, title: "Успешно", message: "Инструкции отправлены\nна Вашу электронную почту")
        } else {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Некорректный адрес\nэлектронной почты")
        }
    }
}

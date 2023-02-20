//
//  LoginViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import Foundation
import SnapKit

enum ViewControllerToPush {
    case signUp
    case resetPassword
}

enum TextField {
    case email
    case password
}

final class LoginViewController: UIViewController {
    
    private var email: String = ""
    
    private var password: String = ""
    
    private var emailTextField = UITextField()
    
    private var passwordTextField = UITextField()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors.buttonColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.setTitle("Вход", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var vStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .horizontal
        
        let label = UILabel()
        label.text = "Нет аккаунта ?"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 13)
        label.textColor = .black
        label.textAlignment = .center
        
        let linkLabel = UILabel()
        linkLabel.text = "Зарегистрироваться"
        linkLabel.font = UIFont(name: "SFProDisplay-Bold", size: 13)
        linkLabel.textColor = Constants.Colors.buttonColor
        linkLabel.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelLinkTapped))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tap)
        
        vs.addArrangedSubview(label)
        vs.addArrangedSubview(linkLabel)
        
        vs.alignment = .center
        vs.distribution = .fillProportionally
        vs.spacing = 6
        return vs
    }()
    
    private lazy var resetPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Сбросить пароль"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 13)
        label.textColor = Constants.Colors.buttonColor
        label.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resetPasswordLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func textField(type: TextField) -> UITextField {
        let tf = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.size.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 20
        tf.placeholder = type == .email ? "Почта" : "Пароль"
        tf.isSecureTextEntry = type == .email ? false : true
        tf.font = UIFont(name: "SFProDisplay-Regular", size: 17)!
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.backgroundColor = Constants.Colors.textFieldColor
        return tf
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        navigationItem.title = "Вход"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Constants.Colors.buttonColor
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        emailTextField = textField(type: .email)
        passwordTextField = textField(type: .password)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(vStack)
        view.addSubview(resetPasswordLabel)
    }
    
    private func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(300)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.width.equalTo(emailTextField)
            make.height.equalTo(emailTextField)
            make.centerX.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(42)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalTo(passwordTextField)
        }
        
        vStack.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(emailTextField).inset(37.5)
        }
        
        resetPasswordLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.width.equalToSuperview()
        }
    }
    


    @objc private func labelLinkTapped() {
        PresenterManager.shared.show(vc: .signUp)
    }
    
    @objc private func resetPasswordLabelTapped() {
        let vc = ResetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func buttonTapped() {
        self.email = emailTextField.text ?? ""
        self.password = passwordTextField.text ?? ""
        
        let storedEmail = Bundle.main.infoDictionary?["StoredEmail"] as? String
        let storedPassword = Bundle.main.infoDictionary?["StoredPassword"] as? String
        
        if self.email.isEmpty || self.password.isEmpty {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Заполните пустые поля")
        } else if !self.email.isValidEmail() {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Проверьте корректность ввода почты")
        } else if self.email == storedEmail && self.password == storedPassword {
            PresenterManager.shared.show(vc: .tabBar)
        } else if CoreDataManager.shared.isUserPresentedInCoreData(email: email, password: password) {
            PresenterManager.shared.show(vc: .tabBar)
        } else {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Указан неправильный логин\nили пароль")
        }
    }
}

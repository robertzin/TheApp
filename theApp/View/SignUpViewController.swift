//
//  SignUpViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var email: String = ""
    
    private var password: String = ""
    
    private var emailTextField = UITextField()
    
    private var passwordTextField = UITextField()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors.buttonColor
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 17)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var vStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .horizontal
        
        let label = UILabel()
        label.text = "У вас есть аккаунт ?"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 13)
        label.textColor = .black
        label.textAlignment = .right
        
        let linkLabel = UILabel()
        linkLabel.text = "Войти"
        linkLabel.font = UIFont(name: "SFProDisplay-Bold", size: 13)
        linkLabel.textColor = Constants.Colors.buttonColor
        linkLabel.textAlignment = .left
        
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
        navigationItem.title = "Регистрация"
        navigationController?.navigationBar.tintColor = Constants.Colors.buttonColor
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        emailTextField = textField(type: .email)
        passwordTextField = textField(type: .password)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(vStack)
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
            make.width.equalTo(loginButton).inset(15)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func labelLinkTapped() {
        PresenterManager.shared.show(vc: .login)
    }
    
    @objc private func buttonTapped() {
        self.email = emailTextField.text ?? ""
        self.password = passwordTextField.text ?? ""
        
        if self.email.isEmpty || self.password.isEmpty {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Заполните пустые поля")
        } else if !email.isValidEmail() {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Проверьте корректность ввода почты")
        } else if !CoreDataManager.shared.isUserEmailPresentedInCoreData(with: email) {
            let idx = email.lastIndex(of: "@")
            let name = String(email[..<idx!])
            
            // MARK: add user to CoreData
            let user = User()
            user.set(name: name, email: email, password: password)
            CoreDataManager.shared.saveContext()
            do { try CoreDataManager.shared.usersFetchResultController.performFetch() }
            catch { debugPrint("Error while saving new user to CoreData in SignUp View: \(error.localizedDescription)") }
            
            PresenterManager.shared.show(vc: .login)
        } else {
            Alert().presentAlert(vc: self, title: "Ошибка", message: "Адрес электронной почты\nуже используется")
        }
    }
}

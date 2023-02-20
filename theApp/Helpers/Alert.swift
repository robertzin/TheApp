//
//  Alert.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

class Alert {
    
    func presentAlert(vc: UIViewController, title: String, message: String) {
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 17)!]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 13)!]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true)
    }
    
    func presentTwoActionAlert(vc: UIViewController, title: String, message: String) {
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 17)!]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 13)!]
        let messageString = NSAttributedString(string: message, attributes: messageAttributes)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default)
        let exitAction = UIAlertAction(title: "Выход", style: .destructive) { action in
            CoreDataManager.shared.deleteAllEntities()
            PresenterManager.shared.show(vc: .login)
            vc.dismiss(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(exitAction)
        
        vc.present(alert, animated: true)
    }
}

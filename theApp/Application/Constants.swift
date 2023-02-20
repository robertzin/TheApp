//
//  Constants.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

enum Constants {
    
    static let getNewsURL: String = "https://newsapi.org/v2/top-headlines"
    static let apiKey: String = "e8a1f316e92c451b8751d5ab466539e2"
    static let adminEmail: String = "test@mail.ru"
    static let adminPassword: String = "12345"
    
    enum NewsVCType {
        case feed
        case favourites
    }
    
    enum Colors {
        static var textFieldColor: UIColor? {
            UIColor(named: "textFieldColor")
        }
        static var alertColor: UIColor? {
            UIColor(named: "alertColor")
        }
        static var buttonColor: UIColor? {
            UIColor(named: "buttonColor")
        }
        static var greyColor: UIColor? {
            UIColor(named: "greyColor")
        }
        static var darkGreyColor: UIColor? {
            UIColor(named: "darkGreyColor")
        }
        static var heartColor: UIColor? {
            UIColor(named: "heartColor")
        }
        static var selectedColor: UIColor? {
            UIColor(named: "selectedColor")
        }
        static var backgroundColor: UIColor? {
            UIColor(named: "backgroundColor")
        }
    }
}

//
//  Constants.swift
//  theApp
//
//  Created by Robert Zinyatullin on 17.02.2023.
//

import UIKit

enum Constants {
    
    static let getNewsURL: String = "https://newsapi.org/v2/top-headlines"
    
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

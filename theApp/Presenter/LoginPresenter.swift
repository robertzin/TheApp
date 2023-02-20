//
//  LoginPresenter.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//

import UIKit

protocol LoginProtocol {
    func openDiskItemView(vc: UIViewController)
}

protocol LoginPresenterProtocol {
    init(view: LoginProtocol)
    func pushViewController(_ type: ViewControllerToPush)
    func ifUserIsPresentedInCoreData(email: String, password: String) -> Bool
    
    var coreDataManager: CoreDataManager { get }
}

final class LoginPresenter: LoginPresenterProtocol {
    var view: LoginProtocol?
    var coreDataManager: CoreDataManager
    
    init(view: LoginProtocol) {
        self.view = view
        self.coreDataManager = CoreDataManager.shared
    }
    
    func pushViewController(_ type: ViewControllerToPush) {
        if type == .resetPassword {
            let vc = ResetPasswordViewController()
            view?.openDiskItemView(vc: vc)
        }
    }
    
    func ifUserIsPresentedInCoreData(email: String, password: String) -> Bool {
        return coreDataManager.isUserPresentedInCoreData(email: email, password: password)
    }
}

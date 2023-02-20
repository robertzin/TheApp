//
//  User+CoreDataClass.swift
//  theApp
//
//  Created by Robert Zinyatullin on 20.02.2023.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    convenience init() {
        self.init(entity: CoreDataManager.shared.entityForName(entityName: "User"), insertInto: CoreDataManager.shared.context)
    }
    
    func set(name: String, email: String, password: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
        self.imageUrl = "https://picsum.photos/200"
    }

}

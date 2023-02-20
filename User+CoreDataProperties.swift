//
//  User+CoreDataProperties.swift
//  theApp
//
//  Created by Robert Zinyatullin on 20.02.2023.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var imageUrl: String?

}

extension User : Identifiable {

}

//
//  CoreDataManager.swift
//  theApp
//
//  Created by Robert Zinyatullin on 19.02.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    lazy var newsFetchResultController: NSFetchedResultsController<Article> = {
        let fetchRequest = Article.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    lazy var favouritedNewsFetchResultController: NSFetchedResultsController<Article> = {
        let fetchRequest = Article.fetchRequest()
        let predicate = NSPredicate(format: "liked == true")
        let sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    lazy var usersFetchResultController: NSFetchedResultsController<User> = {
        let fetchRequest = User.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    func isUserPresentedInCoreData(email: String, password: String) -> Bool {
        let fetchRequest = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            if users.contains(where: { user in
                user.email == email && user.password == password
            }) {
                return true
            }
        } catch { debugPrint("error while isPresented is checked: \(error.localizedDescription)") }
        return false
    }
    
    func isUserEmailPresentedInCoreData(with email: String) -> Bool {
        var isPresented = true
        let fetchRequest = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            if users.first(where: { $0.email == email }) != nil { isPresented = false }
        } catch { debugPrint("error while isPresented is checked: \(error.localizedDescription)") }
        return isPresented
    }
    
    func count() -> Int {
        let fetchRequest = Article.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch { print(error.localizedDescription) }
        return -1
    }
    
    func printUser(user: User) {
        debugPrint("""
            - name: \(user.name ?? "nil")
            - email: \(user.email ?? "nil")
            - password: \(user.password ?? "nil")
            """)
    }
    
    func printArticle(article: Article) {
        debugPrint("""
            - author: \(article.author ?? "nil")
            - title: \(article.title ?? "nil")
            - description: \(article.descript ?? "nil")
            - liked: \(article.liked)
            """)
    }
    
    func printUsers() {
        let fetchRequest = User.fetchRequest()
        do {
            let allData = try context.fetch(fetchRequest)
            for user in allData { printUser(user: user) }
        } catch { debugPrint("error while printing CoreData element: \(error.localizedDescription)") }
    }
    
    func printArticles() {
        let fetchRequest = Article.fetchRequest()
        do {
            let allData = try context.fetch(fetchRequest)
            for article in allData { printArticle(article: article) }
        } catch { debugPrint("error while printing CoreData element: \(error.localizedDescription)") }
    }
    
    func deleteAllEntities() {
        let deleteRequest = Article.fetchRequest()
        do {
            let allData = try context.fetch(deleteRequest)
            for article in allData {
                context.delete(article)
            }
        } catch { debugPrint("error while delete all CoreData: \(error.localizedDescription)") }
        self.saveContext()
    }
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

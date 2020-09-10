import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.value(forKey: Constants.shouldHideSources) == nil {
            UserDefaults.standard.set(true, forKey: Constants.shouldHideSources)
        }
        if UserDefaults.standard.value(forKey: Constants.updateTimeInterval) == nil {
            UserDefaults.standard.set(1, forKey: Constants.updateTimeInterval)
        }
        return true
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
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

    static var persistentContainer : NSPersistentContainer {
         return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
     }
     
     static var viewContext : NSManagedObjectContext {
         return persistentContainer.viewContext
     }
    
}


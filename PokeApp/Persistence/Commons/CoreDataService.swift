//
////
////  CoreDataService.swift
////  PokeApp
////
////  Created by Eduardo Sanches Bocato on 27/05/18.
////  Copyright © 2018 Bocato. All rights reserved.
////
//
//import Foundation
//import CoreData
//import RxSwift
//
//protocol CoreDataServiceProtocol {
//    var coreDataController: CoreDataController { get }
////    func saveObject<T: Codable>(_ codableData: T, binaryData: Data, with entityName: String, using context: CoreDataContext) -> Observable<Void>
//    func findObject<T: NSFetchRequestResult>(with id: Int, of type: T.Type, with entityName: String, from context: CoreDataContext) -> Observable<T?>
//    func findAll<T: NSFetchRequestResult>(of type: T.Type, with entityName: String, from context: CoreDataContext) -> Observable<[T]?>
//    func deleteObject(with id: Int, with entityName: String, using context: CoreDataContext) -> Observable<Void>
//}
//
//class CoreDataService: CoreDataServiceProtocol {
//    
//    // MARK: - Properties
//    var coreDataController: CoreDataController { // remove this, use injection...
//        return CoreDataController.shared
//    }
//    
//    // MARK: - Methods
//    func findObject<T: NSFetchRequestResult>(with id: Int, of type: T.Type, with entityName: String, from context: CoreDataContext) -> Observable<T?> {
//        
//        let coreDataContext: NSManagedObjectContext = context == .background ? coreDataController.backgroundContext : coreDataController.viewContext
//        
//        return Observable.create { observable in
//            
//            coreDataContext.perform {
//                
//                let fetchRequest = NSFetchRequest<T>(entityName: entityName)
//                fetchRequest.predicate = NSPredicate(format: "id ==  %d", id)
//                fetchRequest.fetchLimit = 1
//                
//                do {
//                    let result = try coreDataContext.fetch(fetchRequest)
//                    guard let object = result.first else {
//                        debugPrint("Did not found any object with id = \(id)")
//                        observable.onError(ErrorFactory.buildPersistenceError(with: .notFound))
//                        return
//                    }
//                    observable.onNext(object)
//                } catch let error {
//                    debugPrint("findObject(with id: \(id)) failed with error:\n\(error)")
//                    observable.onError(ErrorFactory.buildPersistenceError(with: error))
//                }
//                
//                observable.onCompleted()
//                
//            }
//            
//            return Disposables.create {
//                try? coreDataContext.save()
//            }
//            
//        }
//        
//    }
//    
//    func findAll<T: NSFetchRequestResult>(of type: T.Type, with entityName: String, from context: CoreDataContext) -> Observable<[T]?> {
//        
//        let coreDataContext: NSManagedObjectContext = context == .background ? coreDataController.backgroundContext : coreDataController.viewContext
//        
//        return Observable.create { observable in
//            
//            coreDataContext.perform {
//                
//                let fetchRequest = NSFetchRequest<T>(entityName: entityName)
//                
//                do {
//                    let objectsFromPersistenceContainer = try coreDataContext.fetch(fetchRequest)
//                    observable.onNext(objectsFromPersistenceContainer)
//                } catch let error {
//                    debugPrint("getAll() failed with error:\n\(error)")
//                    observable.onError(ErrorFactory.buildPersistenceError(with: error))
//                }
//                
//                observable.onCompleted()
//                
//            }
//            
//            return Disposables.create {
//                try? coreDataContext.save()
//            }
//            
//        }
//        
//    }
//    
//    func deleteObject(with id: Int, with entityName: String, using context: CoreDataContext) -> Observable<Void> {
//        
//        let coreDataContext: NSManagedObjectContext = context == .background ? coreDataController.backgroundContext : coreDataController.viewContext
//        
//        return Observable.create { observable in
//            
//            coreDataContext.perform {
//                
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//                fetchRequest.predicate = NSPredicate(format: "id ==  %d", id)
//                fetchRequest.fetchLimit = 1
//                
//                do {
//                    
//                    let result = try coreDataContext.fetch(fetchRequest)
//                    
//                    guard let object = result.first as? NSManagedObject else {
//                        debugPrint("Did not found any object with id = \(id)")
//                        observable.onError(ErrorFactory.buildPersistenceError(with: .notFound)) // TODO: Specialize error
//                        return
//                    }
//                    
//                    // Object found, now we delete it
//                    coreDataContext.delete(object)
//                    do {
//                        try coreDataContext.save()
//                        debugPrint("sucessfully deleted object with id = \(id)")
//                        observable.onNext(())
//                    } catch let error {
//                        debugPrint("coreDataContext.save did fail with error: \n\(error)")
//                        observable.onError(ErrorFactory.buildPersistenceError(with: error))
//                    }
//                    
//                    
//                } catch let error {
//                    debugPrint("findObject(with id: \(id)) failed with error:\n\(error)")
//                    observable.onError(ErrorFactory.buildPersistenceError(with: error))
//                }
//                
//                observable.onCompleted()
//                
//            }
//            
//            return Disposables.create {
//                try? coreDataContext.save()
//            }
//            
//        }
//        
//    }
//    
//    
//}

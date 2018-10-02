////
////  FavoritesService.swift
////  PokeApp
////
////  Created by Eduardo Sanches Bocato on 27/05/18.
////  Copyright © 2018 Bocato. All rights reserved.
////
//
//import Foundation
//import UIKit
//import RxSwift
//import CoreData
//
//
//protocol FavoritesServiceProtocol {
//    var coreDataService: CoreDataServiceProtocol { get }
//    func save(_ pokemon: Pokemon, with image: UIImage) -> Observable<Void>
//    func findFavorite(with id: Int) -> Observable<Pokemon?>
//    func findAllFavorites() -> Observable<[Pokemon]?>
//    func deleteFavorite(with id: Int) -> Observable<Void>
//}
//
//class FavoritesService: FavoritesServiceProtocol {
//    
//    // MARK: - Properties
//    var coreDataService: CoreDataServiceProtocol
//    
//    // MARK: - Initialization
//    init() {
//        self.coreDataService = CoreDataService()
//    }
//    
//    init(coreDataService: CoreDataServiceProtocol) {
//        self.coreDataService = coreDataService
//    }
//    
//    // MARK: - Methods
//    func save(_ pokemon: Pokemon, with image: UIImage) -> Observable<Void> { // TODO: Generalize
//        
//        return Observable.create { observable in
//            
//            guard let id = pokemon.id else {
//                observable.onError(ErrorFactory.buildPersistenceError(with: .unexpected))
//                return Disposables.create() // Is this ok?
//            }
//            
//            let coreDataContext = self.coreDataService.coreDataController.viewContext
//            
//            coreDataContext.perform {
//                
//                guard let dictionaryValue = pokemon.dictionaryValue,
//                    let jsonData = JSON.serialize(dictionary: dictionaryValue),
//                    let imageData = UIImagePNGRepresentation(image) else {
//                        observable.onError(ErrorFactory.buildPersistenceError(with: .unexpected))
//                        return
//                }
//                
//                let favorite = Favorite(context: coreDataContext)
//                favorite.jsonData = jsonData
//                favorite.imageData = imageData
//                
//                do {
//                    try coreDataContext.save()
//                    debugPrint("sucessfully saved object with id = \(id)")
//                    observable.onNext(())
//                } catch let error {
//                    debugPrint("coreDataContext.save did fail with error: \n\(error)")
//                    observable.onError(ErrorFactory.buildPersistenceError(with: error))
//                }
//                
//                observable.onCompleted()
//                
//            }
//            
//            return Disposables.create()
//            
//        }
//        
//    }
//    
//    func findFavorite(with id: Int) -> Observable<Pokemon?> {
//        
//        return Observable.create { observable in
//            
//            return Disposables.create()
//            
//        }
//        
//    }
//    
//    func findAllFavorites() -> Observable<[Pokemon]?> {
//        
//        return Observable.create { observable in
//            
//            return Disposables.create()
//            
//        }
//        
//    }
//    
//    func deleteFavorite(with id: Int) -> Observable<Void> {
//        
//        return Observable.create { observable in
//            
//            return Disposables.create()
//            
//        }
//        
//    }
//    
//}

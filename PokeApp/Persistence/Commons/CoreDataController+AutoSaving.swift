////
////  CoreDataController+AutoSaving.swift
////  PokeApp
////
////  Created by Eduardo Sanches Bocato on 27/05/18.
////  Copyright © 2018 Bocato. All rights reserved.
////
//
//import Foundation
//
//// MARK: - Autosaving
//extension CoreDataController {
//    
//    func autoSaveViewContext(interval:TimeInterval = 30) {
//        
//        debugPrint("Auto saving ViewContext...")
//        
//        guard interval > 0 else { return }
//        
//        saveViewContext()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
//            self.autoSaveViewContext(interval: interval)
//        }
//        
//    }
//    
//}

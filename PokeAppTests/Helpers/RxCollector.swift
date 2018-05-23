//
//  RxCollector.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
//import RxSwift
//
//class RxCollector<T> {
//
//    var bag = DisposeBag()
//    var items = [T]()
//    var error: Error?
//    func collect(from observable: Observable<T>) -> RxCollector {
//        observable.asObservable()
//            .subscribe(onNext: ({ (item) in
//                self.items.append(item)
//            }), onError: { (error) in
//                self.error = error
//            })
//            .disposed(by: bag)
//        return self
//    }
//
//}

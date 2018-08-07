//
//  ObservableExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 07/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func fireSingleEvent(on scheduler: SerialDispatchQueueScheduler? = nil, disposedBy disposeBag: DisposeBag) -> Self {
        guard let scheduler = scheduler else {
            self.asSingle().subscribe().disposed(by: disposeBag)
            return self
        }
        observeOn(scheduler).asSingle().debug().subscribe().disposed(by: disposeBag)
        return self
    }
    
}

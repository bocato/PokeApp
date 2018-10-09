//
//  KingfisherImageDownloader.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 09/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift

class KingfisherImageDownloader: ImageDownloaderProtocol {
    
    func download(with url: URL?) -> Observable<UIImage?> {
        
        return Observable.create({ observable in
            
            guard let url = url else {
                let error = ErrorFactory.buildNetworkError(with: .invalidURL)
                observable.onError(error)
                observable.onCompleted()
                return Disposables.create()
            }
            
            let imageHolder = UIImageView()
            imageHolder.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, _, _) in
                guard let image = image, error == nil else {
                    observable.onError(error!)
                    observable.onCompleted()
                    return
                }
                observable.onNext(image)
                observable.onCompleted()
            }
            
            return Disposables.create()
            
        })
        
    }
    
}



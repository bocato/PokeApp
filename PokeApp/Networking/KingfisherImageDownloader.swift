//
//  KingfisherImageDownloader.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 09/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class KingfisherImageDownloader: ImageDownloaderProtocol {
    
    func download(with url: URL, completionHandler: CompletionHandler?) {
        let imageHolder = UIImageView()
        imageHolder.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, _, _) in
            completionHandler?(image, error)
        }
    }
    
}



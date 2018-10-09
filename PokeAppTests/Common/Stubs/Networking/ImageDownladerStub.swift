//
//  ImageDownladerStub.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 09/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
@testable import PokeApp

class ImageDownloaderStub: ImageDownloaderProtocol {
    
    // MARK: - Properties
    var mockType: MockType
    
    // MARK: - MockTypes
    enum MockType {
        case image(UIImage)
        case blankImage
        case error(NSError)
    }
    
    // MARK: - Initialization
    init(mockType: MockType = .blankImage) {
        self.mockType = mockType
    }
    
    // MARK: -
//    func download(with url: URL, completionHandler: CompletionHandler?) {
//        switch mockType {
//        case .image(let image):
//            completionHandler?(image, nil)
//        case .blankImage:
//            let image = UIImage()
//            completionHandler?(image, nil)
//        case .error(let error):
//            completionHandler?(nil, error)
//        }
//    }
    
}

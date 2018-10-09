//
//  ImageDownloaderProtocol.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 09/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol ImageDownloaderProtocol {
    typealias CompletionHandler = (_ image: UIImage?, _ error: NSError?) -> Void
    func download(with url: URL, completionHandler: CompletionHandler?)
}

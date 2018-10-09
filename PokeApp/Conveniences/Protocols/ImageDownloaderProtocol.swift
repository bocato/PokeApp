//
//  ImageDownloaderProtocol.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 09/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift

protocol ImageDownloaderProtocol {
    func download(with url: URL?) -> Observable<UIImage?>
}

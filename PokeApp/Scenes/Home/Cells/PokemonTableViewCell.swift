//
//  PokemonTableViewCell.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class PokemonTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Configuration
    func configure(with cellModel: PokemonTableViewCellModel) {
        infoLabel.attributedText = buildInfoLabelAttributedText(from: cellModel)
        bindImageView(to: cellModel)
    }
    
    func bindImageView(to cellModel: PokemonTableViewCellModel) {
        
        cellModel.state
            .asObservable()
            .subscribe(onNext: { (state) in
                switch state {
                case .loading(let isLoading):
                    self.showImageViewLoader(isLoading)
                default: return
                }
            }).disposed(by: disposeBag)
        
        cellModel.pokemonImage
            .asObservable()
            .subscribe(onNext: { (image) in
                self.pokemonImageView.image = image
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: - Helpers
    private func showImageViewLoader(_ show: Bool) {
        if show {
            pokemonImageView.startLoading()
        } else {
            pokemonImageView.stopLoading()
        }
    }
    
    private func buildNumberAttributedString(from numberString: String) -> NSMutableAttributedString {
        let numberAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        return NSMutableAttributedString(string: numberString, attributes: numberAttributes)
    }
    
    private func buildNameAttributedString(from name: String) -> NSAttributedString {
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.darkText
        ]
        return NSAttributedString(string: name, attributes: nameAttributes)
    }
    
    private func buildInfoLabelAttributedText(from cellModel: PokemonTableViewCellModel) -> NSAttributedString {
        let numberAttributedString = buildNumberAttributedString(from: cellModel.pokemonNumberString)
        let nameAttributedString = buildNameAttributedString(from: cellModel.pokemonName)
        numberAttributedString.append(nameAttributedString)
        return numberAttributedString
    }
    
}

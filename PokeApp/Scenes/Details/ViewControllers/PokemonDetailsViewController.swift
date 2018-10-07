//
//  PokemonDetailsViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 22/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonDetailsViewController: UIViewController, RxControllable {
    
    // MARK: Aliases
    typealias ViewModelType = PokemonDetailsViewModel
    
    // MARK: - IBOutlets
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var abilitiesTableView: UITableView!
    @IBOutlet private weak var statsTableView: UITableView!
    @IBOutlet private weak var movesTableView: UITableView!
    @IBOutlet private weak var favoritesButton: PrimaryButton!
    
    // MARK: - Properties
    internal(set) var viewModel: PokemonDetailsViewModel!
    internal(set) var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
        viewModel.loadPokemonData()
    }
    
}

// MARK: - Binding
extension PokemonDetailsViewController {
    
    internal func bindAll() {
        bindViewModel()
        bindImage()
        bindLabels()
        bindTableViews()
        bindButtons()
    }
    
    private func bindViewModel() {
        
        viewModel.isLoadingPokemonImage
            .asObservable()
            .subscribe(onNext: { [weak self] (isLoading) in
                if isLoading {
                    self?.pokemonImageView.startLoading()
                } else {
                    self?.pokemonImageView.stopLoading()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.viewState
            .asDriver()
            .drive(onNext: { [weak self] (state) in
                guard let `self` = self else { return }
                switch state {
                case .error(let networkError):
                    let errorMessage = networkError?.message ?? NetworkErrorMessage.unexpected.rawValue
                    AlertHelper.showAlert(in: self, withTitle: "Error", message: errorMessage, preferredStyle: .actionSheet, action: UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (_) in
                        self?.navigationController?.popViewController(animated: true)
                    }))
                default: return
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindImage() {
        viewModel.pokemonImage
            .asObservable()
            .bind(to: pokemonImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func bindLabels() {
        
        viewModel.pokemonNumber
            .asObservable()
            .bind(to: numberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pokemonName
            .asObservable()
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func bindTableViews() {
        
        viewModel.pokemonAbilities
            .asObservable()
            .bind(to: abilitiesTableView.rx.items(cellIdentifier: "AbilitiesTableViewCell", cellType: UITableViewCell.self)) { (rowIndex, abilityString, cell) in
                cell.textLabel?.text = abilityString
            }
            .disposed(by: disposeBag)
        
        viewModel.pokemonStats
            .asObservable()
            .bind(to: statsTableView.rx.items(cellIdentifier: "StatsTableViewCell", cellType: UITableViewCell.self)) { (rowIndex, statString, cell) in
                cell.textLabel?.text = statString
            }
            .disposed(by: disposeBag)
        
        viewModel.pokemonMoves
            .asObservable()
            .bind(to: movesTableView.rx.items(cellIdentifier: "MovesTableViewCell", cellType: UITableViewCell.self)) { (rowIndex, moveString, cell) in
                cell.textLabel?.text = moveString
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindButtons() {
        
        favoritesButton.rx.tap.subscribe { onTap in
            self.viewModel.actOnFavoritesButtonTouch()
            }.disposed(by: disposeBag)
        
        viewModel.favoriteButtonText
            .asObservable()
            .bind(to: favoritesButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - UITableViewDelegate
extension PokemonDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
}


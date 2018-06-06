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

class PokemonDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var abilitiesTableView: UITableView!
    @IBOutlet private weak var statsTableView: UITableView!
    @IBOutlet private weak var movesTableView: UITableView!
    @IBOutlet private weak var favoritesButton: PrimaryButton!
    
    // MARK: - Properties
    var viewModel: PokemonDetailsViewModelProtocol!
    private var disposeBag = DisposeBag()
    
    // MARK: - Instantiation
    class func newInstanceFromStoryBoard(viewModel: PokemonDetailsViewModelProtocol) -> PokemonDetailsViewController {
        let controller = instantiate(viewControllerOfType: PokemonDetailsViewController.self, storyboardName: "Details")
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
    }

}

// MARK: - Binding
private extension PokemonDetailsViewController {
    
    func bindAll() {
        bindViewModel()
        bindImage()
        bindLabels()
        bindTableViews()
        bindButtons()
    }
    
    func bindViewModel() {
        
        viewModel.loadPokemonData()
        
        viewModel.isLoadingPokemonImage
            .asObservable()
            .subscribe(onNext: { isLoading in
                if isLoading {
                    self.pokemonImageView.startLoading(backgroundColor: UIColor.white, activityIndicatorColor: UIColor.lightGray)
                } else {
                    self.pokemonImageView.stopLoading()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.viewState
            .asObservable()
            .subscribe(onNext: { state in
                switch state {
                    case .loading(let isLoading):
                        if isLoading {
                            self.abilitiesTableView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
                            self.statsTableView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
                            self.movesTableView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
                            self.favoritesButton.startLoading(backgroundColor: UIColor.white, activityIndicatorColor: UIColor.lightGray)
                        } else {
                            self.abilitiesTableView.stopLoading()
                            self.statsTableView.stopLoading()
                            self.movesTableView.stopLoading()
                            self.favoritesButton.stopLoading()
                        }
                    case .error(let networkError):
                        let errorMessage = networkError.message ?? NetworkErrorMessage.unexpected.rawValue
                        AlertHelper.showAlert(in: self, withTitle: "Error", message: errorMessage, preferredStyle: .actionSheet)
                    case .noData:
                        debugPrint("No Data") // PopViewController... do this with Cooordinator
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindImage() {
        viewModel.pokemonImage
            .asObservable()
            .bind(to: pokemonImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    func bindLabels(){
        
        viewModel.pokemonNumber
            .asObservable()
            .bind(to: numberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pokemonName
            .asObservable()
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func bindTableViews() {
        
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
    
    func bindButtons() {
        
        favoritesButton.rx.tap.subscribe { onTap in
            self.viewModel.favoriteButtonTouchUpInsideActionClosure?()
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


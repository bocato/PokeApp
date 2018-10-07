//
//  HomeViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeViewController: UIViewController, RxControllable {
    
    // MARK: - Aliases
    typealias ViewModelType = HomeViewModel
    
    // MARK: - Constants
    private struct ViewConstants {
        static let defaultTableviewCellHeight: CGFloat = 100.0
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Dependencies
    internal(set) var viewModel: HomeViewModel!
    internal(set) var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
        viewModel.loadPokemons()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
}

// MARK: - Binding
extension HomeViewController {
    
    internal func bindAll() {
        bindViewModel()
        bindTableView()
    }
    
    private func bindViewModel() {
        
        viewModel.viewState
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                switch state {
                case .error(let networkError):
                    let errorMessage = networkError?.message ?? NetworkErrorMessage.unexpected.rawValue
                    AlertHelper.showAlert(in: self, withTitle: "Error", message: errorMessage, preferredStyle: .actionSheet)
                case .empty:
                    self.tableView.isHidden = true
                default: return
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindTableView()  {
        
        viewModel.pokemonCellModels
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: PokemonTableViewCell.identifier, cellType: PokemonTableViewCell.self)) { (rowIndex, pokemonCellModel, cell) in
                cell.configure(with: pokemonCellModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(PokemonTableViewCellModel.self)
            .subscribe(onNext: { (selectedPokemonCellModel) in
                self.viewModel.showItemDetailsForSelectedCellModel(selectedPokemonCellModel)
            })
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewConstants.defaultTableviewCellHeight
    }
    
}

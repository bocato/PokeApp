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

class HomeViewController: UIViewController {
    
    // MARK: - Constants
    private struct ViewConstants {
        static let defaultTableviewCellHeight: CGFloat = 100.0
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Dependencies
    var viewModel: HomeViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: - ViewElements
    fileprivate var refreshControl: UIRefreshControl = ({
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        return refreshControl
    })()
    
    class func newInstanceFromStoryboard(viewModel: HomeViewModel) ->  HomeViewController {
        let controller = HomeViewController.instantiate(viewControllerOfType: HomeViewController.self, storyboardName: "Home")
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.refreshControl = refreshControl
        bindAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // tests
//        if RemoteConfigs.shared.areRefactorTestsEnabled {
//           AlertHelper.showAlert(in: self, withTitle: "TEST!", message: "Refactor tests are ENABLED!")
//        } else {
//          AlertHelper.showAlert(in: self, withTitle: "TEST!", message: "Refactor tests are DISABLED!")
//        }
//
//
//    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
}

// MARK: - Binding
private extension HomeViewController {
    
    func bindAll() {
        bindViewModel()
        bindTableView()
//        bindRefreshControl()
    }
    
    func bindViewModel() {
        
        viewModel.loadPokemons()
            .subscribeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.viewState
            .observeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { state in
                switch state {
                case .loading(let isLoading):
                    if isLoading {
                        self.tableView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
                    } else {
                        self.tableView.stopLoading()
                    }
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
            .observeOn(MainScheduler.instance)
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
    
    func bindRefreshControl() {
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.viewModel.loadPokemons()
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

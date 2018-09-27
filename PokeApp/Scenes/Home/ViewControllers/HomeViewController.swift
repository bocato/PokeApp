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
    @IBOutlet weak var textField: UITextField!
    
    var textOutput = BehaviorRelay<String>()
    
    // MARK: - Dependencies
    var viewModel: HomeViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: - Instantiation
    class func newInstanceFromStoryboard(viewModel: HomeViewModel) ->  HomeViewController {
        let controller = HomeViewController.instantiate(viewControllerOfType: HomeViewController.self, storyboardName: "Home")
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.loadPokemons(using: disposeBag)
        bindAll()
        
        
        
        textOutput.b
        
        textField.rx.text
        
        textField.rx.controlEvent([.editingChanged]).bind(to: <#T##(ControlEvent<()>) -> (R1) -> R2#>, curriedArgument: <#T##R1#>)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // tests
//        if RemoteConfigs.shared.areRefactorTestsEnabled {
//           AlertHelper.showAlert(in: self, withTitle: "TEST!", message: "Refactor tests are ENABLED!")
//        } else {
//          AlertHelper.showAlert(in: self, withTitle: "TEST!", message: "Refactor tests are DISABLED!")
//        }
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
    }
    
    func bindViewModel() {
        
        viewModel.viewState
            .observeOn(MainScheduler.instance)
            .asObservable()
            .subscribe(onNext: { state in
                switch state {
                case .common(let commonState):
                    handleCommonViewState(commonState)
                }
            })
            .disposed(by: disposeBag)
        
        func handleCommonViewState(_ state: CommonViewModelState) {
            switch state {
            case .loading(let isLoading):
//                if isLoading { // tá bugando, consertar depois
//                    self.tableView.startLoading(backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.lightGray)
//                } else {
//                    self.tableView.stopLoading()
//                }
                DebugLog(format: "\(isLoading)")
            case .error(let networkError):
                let errorMessage = networkError?.message ?? NetworkErrorMessage.unexpected.rawValue
                AlertHelper.showAlert(in: self, withTitle: "Error", message: errorMessage, preferredStyle: .actionSheet)
            case .empty:
                self.tableView.isHidden = true
            default: return
            }
        }
        
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
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewConstants.defaultTableviewCellHeight
    }
    
}

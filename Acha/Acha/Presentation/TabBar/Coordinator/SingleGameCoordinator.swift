//
//  SingleGameCoordinator.swift
//  Acha
//
//  Created by 조승기 on 2022/11/16.
//

import UIKit

protocol SingleGameCoordinatorProtocol: Coordinator {
    func showSelectMapViewController()
    func showSingleGamePlayViewController(selectedMap: Map)
}

final class SingleGameCoordinator: SingleGameCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    weak var delegate: CoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        showSelectMapViewController()
    }
    
    func showSelectMapViewController() {
        let viewModel = SelectMapViewModel(coordinator: self)
        let viewController = SelectMapViewController(viewModel: viewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSingleGamePlayViewController(selectedMap: Map) {
        let viewModel = SingleGameViewModel(
            map: selectedMap,
            coordinator: self,
            singeGameUseCase: DefaultSingleGameUseCase(
                map: selectedMap,
                locationService: DefaultLocationService(),
                recordRepository: DefaultRecordRepository(
                    realTimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                ),
                tapTimer: TimerService(),
                runningTimer: TimerService()
            )
        )
        let viewController = SingleGameViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showInGameRecordViewController(mapID: Int) {
        let viewModel = InGameRecordViewModel(
            inGameUseCase: DefaultInGameUseCase(
                mapID: mapID,
                recordRepository: DefaultRecordRepository(
                    realTimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                )
            )
        )
        let viewController = InGameRecordViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .pageSheet
        self.navigationController.viewControllers.last?.present(viewController, animated: true)
    }
    
    func showInGameRankViewController(mapID: Int) {
        let viewModel = InGameRankingViewModel(
            inGameUseCase: DefaultInGameUseCase(
                mapID: mapID,
                recordRepository: DefaultRecordRepository(
                    realTimeDatabaseNetworkService: DefaultRealtimeDatabaseNetworkService()
                )
            )
        )
        let viewController = InGameRankingViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .pageSheet
        self.navigationController.viewControllers.last?.present(viewController, animated: true)
    }
}

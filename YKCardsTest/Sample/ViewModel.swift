//
//  ViewModel.swift
//  YKCardsTest
//
//  Created by Yury Karpenka on 19.11.2023.
//

import UIKit
import FirebaseRemoteConfig

protocol ViewModelType {
    func fetchRemoteConfigs()
}

protocol ViewModelDelegate: AnyObject {
    func applySnapshot(snapshot: NSDiffableDataSourceSnapshot<Int, CardItem>)
}

final class ViewModel: ViewModelType {
    
    private let remoteConfig: RemoteConfig
    private var listiner: ConfigUpdateListenerRegistration?
    
    weak var delegate: ViewModelDelegate?
    
    init(
        remoteConfig: RemoteConfig = .remoteConfig(),
        delegate: ViewModelDelegate? = nil
    ) {
        self.remoteConfig = remoteConfig
        self.delegate = delegate
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 1
        remoteConfig.configSettings = settings
    }
    
    func fetchRemoteConfigs()  {
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                self?.remoteConfig.activate { status, error in
                    self?.updateCards()
                }
            } else {
                print("Config not fetched")
            }
        }
        listiner = remoteConfig.addOnConfigUpdateListener { [weak self] configUpdate, error in
            guard error == nil else {
                return
            }
            self?.remoteConfig.activate { status, error in
                self?.updateCards()
            }
        }
    }
    
    private func updateCards() {
        let configKeys = remoteConfig.allKeys(from: .remote)
        var cardItems = configKeys.map {
            let imageUrl = remoteConfig.configValue(forKey: $0).stringValue
            return CardItem(id: $0, imageUrl: imageUrl ?? "")
        }
        if cardItems.count > 6 {
            cardItems = Array(cardItems[0..<6])
        }
        var snapshot = ViewController.CollectionViewSnashot()
        snapshot.appendSections([0])
        snapshot.appendItems(cardItems)
        delegate?.applySnapshot(snapshot: snapshot)
    }
    
}

//
//  ViewController.swift
//  YKCardsTest
//
//  Created by Yury Karpenka on 17.11.2023.
//

import UIKit
import SnapKit


final class ViewController: UIViewController {
    
    typealias CollectionViewSnashot = NSDiffableDataSourceSnapshot<Int, CardItem>
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: portraitLayout)
    private var dataSource: UICollectionViewDiffableDataSource<Int, CardItem>! = nil
    
    private lazy var viewModel: ViewModelType = ViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchRemoteConfigs()
        setupCollectionView()
        setupDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCollectionViewLayout()
    }
}

private extension ViewController {
    func setupCollectionView() {
        collectionView.registerClassCell(CardCollectionViewCell.self)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CardItem>(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: itemIdentifier)
            return cell
        })
    }
    
    func setCollectionViewLayout() {
        if UIDevice.current.orientation.isPortrait {
            collectionView.setCollectionViewLayout(portraitLayout, animated: true)
        } else {
            collectionView.setCollectionViewLayout(landscapeLayout, animated: true)
        }
    }
    
    var portraitLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    var landscapeLayout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ViewController: ViewModelDelegate {
    func applySnapshot(snapshot: CollectionViewSnashot) {
        dataSource.apply(snapshot)
    }
}

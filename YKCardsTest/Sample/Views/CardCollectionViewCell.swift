//
//  CardCollectionViewCell.swift
//  YKCardsTest
//
//  Created by Yury Karpenka on 19.11.2023.
//

import UIKit
import Kingfisher

final class CardCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func configure(with item: CardItem) {
        guard let url = URL(string: item.imageUrl) else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let result):
                self.imageView.image = result.image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

private extension CardCollectionViewCell {
    func setupViews() {
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


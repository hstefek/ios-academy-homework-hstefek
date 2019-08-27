//
//  HomeTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 7/26/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Kingfisher

final class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var showImage: UIImageView!
    @IBOutlet private weak var showTitle: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showImage.image = nil
        showTitle.text = nil
    }
    
}

// MARK: - Configure
extension HomeTableViewCell {
    func configure(with item: Show) {
        showImage.kf.setImage(with: URL(string: "https://api.infinum.academy" + item.imageUrl))
        showTitle.text = item.title
    }
}

// MARK: - Private
private extension HomeTableViewCell {
    func setupUI() {
        showTitle.sizeToFit()
        showImage.layer.cornerRadius = 20
    }
}


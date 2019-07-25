//
//  HomeTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 7/26/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var slika: UIImageView!
    @IBOutlet weak var naslov: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        slika.image = nil
        naslov.text = nil
    }
    
}

// MARK: - Configure
extension HomeTableViewCell {
    func configure(with item: Show) {
        slika.image = UIImage(named: "icImagePlaceholder")
        naslov.text = item.title
    }
}

// MARK: - Private
private extension HomeTableViewCell {
    func setupUI() {
        slika.layer.cornerRadius = 20
    }
}


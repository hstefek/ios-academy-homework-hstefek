//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 7/25/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Private UI
    @IBOutlet weak var naslov: UILabel!
    @IBOutlet weak var slika: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // One of THE MOST important function in UITableViewCell
        // This method will be called before your cell gets dequeued
        // So this will give you time to "reset" the data you have in this cell
        // Failure to do so can result in wrong data in the wrong cell
        // Imageine that one cell is missing its thumbnail image,
        // and you reuse cell and you don't clean the thumbnail, you will have that same thumbnail once cell is reused.
        
        slika.image = nil
        naslov.text = nil
    }
    
}

// MARK: - Configure
extension TVShowTableViewCell {
    func configure(with item: TVShowItem) {
        // Here we are using conditional unwrap, meaning if we have the image, use that, if not, fallback to placeholder image.
        slika.image = item.image ?? UIImage(named: "icImagePlaceholder")
        naslov.text = item.name
    }
}

// MARK: - Private
private extension TVShowTableViewCell {
    func setupUI() {
        slika.layer.cornerRadius = 20
    }
}

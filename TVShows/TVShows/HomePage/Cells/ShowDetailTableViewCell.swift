//
//  ShowDetailTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 7/26/19.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class ShowDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var season: UILabel!
    @IBOutlet private weak var episode: UILabel!
    @IBOutlet private weak var episodeTitle: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        season.text = nil
        episode.text = nil
        episodeTitle.text = nil
    }
    
}

// MARK: - Configure
extension ShowDetailTableViewCell {
    func configure(with item: ShowEpisodes) {
        season.text = "S\(item.season)"
        episode.text = "E\(item.episodeNumber)"
        episodeTitle.text = item.title
    }
}

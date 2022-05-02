//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 30/04/22.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 18, weight : .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 15, weight : .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame :CGRect){
        super.init(frame: frame)
        //contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
//        contentView.backgroundColor = .red
    }
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height - 30,
            width: contentView.width-6,
            height: 30)
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-60,
            width: contentView.width-6,
            height: 35)
        let imageSize = contentView.width - 70
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width - imageSize)/2,
            y: 10,
            width: imageSize,
            height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with viewModel : FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 03/05/22.
//

import Foundation
import UIKit

class AlbumTrackCollectionViewCell : UICollectionViewCell{
    static let identifier  = "AlbumTrackCollectionViewCell"
    
//    private let albumCoverImageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "photo")
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
    private let trackNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 17, weight : .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 15, weight : .light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame :CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        //contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
//        contentView.backgroundColor = .red
    }
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        albumCoverImageView.frame = CGRect(
//            x: 5,
//            y: 5,
//            width: contentView.height-4,
//            height: contentView.height-10)
        trackNameLabel.frame = CGRect(
            x: 10,
            y: 5,
            width: contentView.width-15,
            height: contentView.height/2)
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width-15,
            height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        //albumCoverImageView.image = nil
    }
    
    func configure(with viewModel : AlbumTrackCollectionViewCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        //albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }

}

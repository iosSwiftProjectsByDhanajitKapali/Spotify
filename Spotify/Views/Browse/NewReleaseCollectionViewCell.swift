//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 30/04/22.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 22, weight : .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let noOfTracksLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 18, weight : .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 18, weight : .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame :CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(noOfTracksLabel)
    }
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        noOfTracksLabel.sizeToFit()
        
        let imageSize : CGFloat = contentView.height-10
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        noOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel : NewReleaseCellViewModel){
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        noOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

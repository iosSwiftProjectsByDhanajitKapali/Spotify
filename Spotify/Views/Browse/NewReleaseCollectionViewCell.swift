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
        label.font = .systemFont(ofSize : 20, weight : .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let noOfTracksLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 15, weight : .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 16, weight : .regular)
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
        contentView.clipsToBounds = true
    }
    
    required init?(coder : NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = contentView.height-10
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-imageSize-10, height: contentView.height-10))
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        noOfTracksLabel.sizeToFit()
        
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: 5, width: albumLabelSize.width, height: min(55,albumLabelSize.height))
        //albumNameLabel.backgroundColor = .red
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: albumNameLabel.height + 10, width: contentView.width - albumCoverImageView.width - 5, height: 30)
        //artistNameLabel.backgroundColor = .blue
        noOfTracksLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: contentView.bottom - 30, width: noOfTracksLabel.width + 10, height: 30)
        //noOfTracksLabel.backgroundColor = .green
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

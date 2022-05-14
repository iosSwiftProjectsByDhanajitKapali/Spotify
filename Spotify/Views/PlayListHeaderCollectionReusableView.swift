//
//  PlayListHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 02/05/22.
//

import UIKit
import SDWebImage

protocol PlayListHeaderCollectionReusableViewDelegate : AnyObject{
    func PlayListHeaderCollectionReusableViewDidTapPlayApp(_ header : PlayListHeaderCollectionReusableView)
}

final class PlayListHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlayListHeaderCollectionReusableView"
    
    weak var delegate : PlayListHeaderCollectionReusableViewDelegate?
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 22, weight : .semibold)
        //label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 15, weight : .regular)
        label.textColor = .secondaryLabel
        //label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize : 12, weight : .semibold)
        //label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let playlistImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playAllButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = height/1.75
        playlistImageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: playlistImageView.bottom-60, width: width-20, height: 30)
        
        descriptionLabel.frame = CGRect(x: 10, y: height-80, width: width-85, height: 55)
        
        ownerLabel.frame = CGRect(x: 10, y: height-30, width: width-20, height: 30)
        playAllButton.frame = CGRect(x: width-70, y: height-70, width: 60, height: 60)
        
    }
    
    func configure(with viewModel : PlaylistHeaderViewModel){
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(with: viewModel.artworkURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
    
    @objc private func didTapPlayAll(){
        delegate?.PlayListHeaderCollectionReusableViewDidTapPlayApp(self)
    }
}

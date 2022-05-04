//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 04/05/22.
//

import UIKit
import SDWebImage

struct SearchResultDefaultTableViewCellViewModel {
    let title : String
    let imageURL : URL?
}

class SearchResultDefaultTableViewCell: UITableViewCell {

    static let identifier = "SearchResultDefaultTableViewCell"
    
    // MARK: - Private Methods
    private let label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height-10
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        label.frame = CGRect(x: iconImageView.right+10, y: 0, width: contentView.width-iconImageView.right+15, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    
    func configure(with viewModel : SearchResultDefaultTableViewCellViewModel){
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }

}

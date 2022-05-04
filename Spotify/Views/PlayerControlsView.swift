//
//  PlayerControlsView.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 04/05/22.
//

import UIKit

protocol PlayerControlsViewDelegate : AnyObject{
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView : PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView : PlayerControlsView)
    func playerControlsViewDidTapBackButton(_ playerControlsView : PlayerControlsView)
}

struct PlayerControlsViewViewModel {
    let title : String?
    let subtitle : String?
}


final class PlayerControlsView : UIView{
    
    weak var delegate : PlayerControlsViewDelegate?
    
    // MARK: - Private Data Members
    private let volumeSlider : UISlider = {
       let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize : 20, weight : .semibold)
        label.text = "This is My Song"
        return label
    }()
    
    private let subtitleLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize : 18, weight : .regular)
        label.textColor = .secondaryLabel
        label.text = "Drake (feat. Other Artist"
        return label
    }()
    
    private let backButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton : UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - LifeCycle
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        clipsToBounds = true
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        volumeSlider.frame = CGRect(x: 10, y: bottom-120-60, width: width-20, height: 44)
        let buttonSize  : CGFloat = 60
        playPauseButton.frame = CGRect(x: (width-buttonSize)/2, y: bottom-120, width: buttonSize, height: buttonSize)
        //playPauseButton.backgroundColor = .gray
        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: bottom-120, width: buttonSize, height: buttonSize)
        //backButton.backgroundColor = .blue
        nextButton.frame = CGRect(x: playPauseButton.right+80, y: bottom-120, width: buttonSize, height: buttonSize)
        //nextButton.backgroundColor = .green
    }
    
    func configure(with viewModel : PlayerControlsViewViewModel){
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
}


// MARK: - Private Methods
private extension PlayerControlsView{
    @objc func didTapBack(){
        delegate?.playerControlsViewDidTapBackButton(self)
    }
    
    @objc func didTapNext(){
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc func didTapPlayPause(){
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
    }
}

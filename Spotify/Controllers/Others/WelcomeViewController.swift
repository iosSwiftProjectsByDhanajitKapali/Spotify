//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Private Data Members
    private let signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("SignIn with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let backGroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
         return imageView
    }()
    
    
    private let overLayView : UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon")
         return imageView
    }()
    
    
    private let label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize : 32, weight : .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go."
        return label
    }()
   
}


// MARK: - LifeCycle Methods
extension WelcomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .black
        view.addSubview(backGroundImageView)
        view.addSubview(overLayView)
         
        //add the signIn button
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(logoImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backGroundImageView.frame = view.bounds
        overLayView.frame = view.bounds
        signInButton.frame = CGRect(
            x: 20,
            y: view.bottom - 80 - view.safeAreaInsets.bottom ,
            width: view.width - 50,
            height: 50
        )
        logoImageView.frame = CGRect(
            x: (view.width-120)/2,
            y: (view.height-120)/2,
            width: 120,
            height: 120
        )
        label.frame = CGRect(
            x: 30,
            y: (view.height+150)/2,
            width: view.width-60,
            height: 150
        )
    }
}


// MARK: - Private Methods
private extension WelcomeViewController{
    
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.completionHandler = { [weak self]success in
            DispatchQueue.main.async {
                self?.handleSignIn(success : success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func handleSignIn(success : Bool){
        //Login user or tell them for error
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong while signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}

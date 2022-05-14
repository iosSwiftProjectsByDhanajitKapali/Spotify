//
//  SettingsViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Private Data Members
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
}

// MARK: - LifeCycle Methods
extension SettingsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        configureModels()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - Private Methods
private extension SettingsViewController{
    func configureModels(){
        sections.append(Section(title: "Profile", options: [Option(title: "Your Profile", handler: {
            [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: {
            [weak self] in
            DispatchQueue.main.async {
                self?.signOutButtonTapped()
            }
        })]))
    }
    
    func signOutButtonTapped(){
        let alert = UIAlertController(title: "Sign out", message: "Are You Sure", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            
            AuthManager.shared.signOut { [weak self]isSignedOut in
                if isSignedOut{
                    DispatchQueue.main.async {
                        let navVC = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: {
                            self?.navigationController?.popToRootViewController(animated: false)
                        })
                    }
                }
            }
            
        }))
        present(alert, animated: true)
        
    }
    
    func viewProfile(){
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Delegate, DataSource
extension SettingsViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
}

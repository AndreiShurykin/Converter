//
//  LaunchViewController.swift
//  converter
//
//  Created by Andrei Shurykin on 10.02.22.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    private var authorNameLabel = UILabel()
    private var appNameLabel = UILabel()
    private var appVersionLabel = UILabel()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let secondsToDelay = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            let firstViewController = FirstViewController()
            self.navigationController?.pushViewController(firstViewController, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        authorNameLabel.adjustsFontSizeToFitWidth = true
        authorNameLabel.textColor = .black
        authorNameLabel.textAlignment = .center
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.text = "Created by Andrei Shurykin"
        
        appNameLabel.adjustsFontSizeToFitWidth = true
        appNameLabel.textColor = .black
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let appName = Bundle.main.infoDictionary?["CFBundleDisplayName" as String] as? String else { return }
        appNameLabel.text = appName
        
        appVersionLabel.adjustsFontSizeToFitWidth = true
        appVersionLabel.textColor = .black
        appVersionLabel.textAlignment = . center
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        appVersionLabel.text = "Version " + appVersion
        
        self.view.addSubview(authorNameLabel)
        self.view.addSubview(appNameLabel)
        self.view.addSubview(appVersionLabel)
        
        authorNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        authorNameLabel.rightAnchor.constraint(equalTo: appVersionLabel.leftAnchor).isActive = true
        authorNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3).isActive = true
        authorNameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        authorNameLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor).isActive = true
        authorNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        appNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        appNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        appNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        appNameLabel.bottomAnchor.constraint(equalTo: authorNameLabel.topAnchor).isActive = true
        
        appVersionLabel.leftAnchor.constraint(equalTo: authorNameLabel.rightAnchor).isActive = true
        appVersionLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        appVersionLabel.topAnchor.constraint(equalTo: authorNameLabel.topAnchor).isActive = true
        appVersionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


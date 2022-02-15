//
//  SecondViewController.swift
//  converter
//
//  Created by Andrei Shurykin on 15.02.22.
//

import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    func setCurrentRate(_ value: Double)
    func setFirstCurrency(_ value: String)
    func setSecondCurrency(_ value: String)
}

final class SecondViewController: UIViewController {
    
    weak var secondViewControllerDelegate: SecondViewControllerDelegate?
    
    var firstCurrentCurrency = ""
    var secondCurrentCurrency = ""
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let firstButton: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.setTitle("Tap to choose a currency", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(firstButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        return button
    }()
    
    private let secondButton: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.setTitle("Tap to choose a currency", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(secondButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        return button
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if firstCurrentCurrency != "" {
            firstButton.setTitle(firstCurrentCurrency, for: .normal)
        }
        if secondCurrentCurrency != "" {
            secondButton.setTitle(secondCurrentCurrency, for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        if DataManager.shared.isCurrencyChanged(firstButton.titleLabel?.text, secondButton.titleLabel?.text, firstCurrentCurrency, secondCurrentCurrency) {
            guard let firstText = firstButton.titleLabel?.text else {
                return
            }
            guard let secondText = secondButton.titleLabel?.text else {
                return
            }
            firstCurrentCurrency = firstText
            secondCurrentCurrency = secondText
            if DataManager.shared.checkCurrencies(firstButton.titleLabel?.text, secondButton.titleLabel?.text) {
                DataManager.shared.getCurrencyRate(firstButton.titleLabel?.text, secondButton.titleLabel?.text) { [weak self] result in
                    switch result {
                    case .success(let rate):
                        guard let self = self else {
                            return
                        }
                        self.secondViewControllerDelegate?.setCurrentRate(rate)
                    case .failure(_):
                        print("Error")
                    }
                }
            }
        }

    }
    
    @objc private func firstButtonPressed(sender: UIButton) {
        showAlertController(sender, firstImageView)
    }
    
    @objc private func secondButtonPressed(sender: UIButton) {
        showAlertController(sender, secondImageView)
    }
    
    @objc private func doneButtonPressed(sender: UIButton) {
        secondViewControllerDelegate?.setFirstCurrency(firstCurrentCurrency)
        secondViewControllerDelegate?.setSecondCurrency(secondCurrentCurrency)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        self.view.addSubview(firstImageView)
        self.view.addSubview(secondImageView)
        self.view.addSubview(firstButton)
        self.view.addSubview(secondButton)
        self.view.addSubview(doneButton)
        
        firstImageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        firstImageView.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        firstImageView.bottomAnchor.constraint(equalTo: firstButton.topAnchor, constant: -10).isActive = true
        
        secondImageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        secondImageView.centerXAnchor.constraint(equalTo: secondButton.centerXAnchor).isActive = true
        secondImageView.bottomAnchor.constraint(equalTo: secondButton.topAnchor, constant: -10).isActive = true
        
        firstButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        firstButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2, constant: -15).isActive = true
        firstButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        secondButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2, constant: -10).isActive = true
        secondButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        secondButton.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor).isActive = true
        secondButton.topAnchor.constraint(equalTo: firstButton.topAnchor).isActive = true
        
        doneButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 10).isActive = true
        doneButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
    }
    
    private func showAlertController(_ sender: UIButton,_ imageView: UIImageView) {
        let alertController = UIAlertController(title: "Choose a currency", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: byn, style: .default, handler: { (_) in
            sender.setTitle(byn, for: .normal)
            self.updateImageView(sender, imageView)
        }))
        alertController.addAction(UIAlertAction(title: eur, style: .default, handler: { (_) in
            sender.setTitle(eur, for: .normal)
            self.updateImageView(sender, imageView)
        }))
        alertController.addAction(UIAlertAction(title: rub, style: .default, handler: { (_) in
            sender.setTitle(rub, for: .normal)
            self.updateImageView(sender, imageView)
        }))
        alertController.addAction(UIAlertAction(title: usd, style: .default, handler: { (_) in
            sender.setTitle(usd, for: .normal)
            self.updateImageView(sender, imageView)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true)
    }
    
    private func updateImageView(_ button: UIButton,_ imageView: UIImageView) {
        guard let text = button.titleLabel?.text else {
            return
        }
        imageView.image = UIImage(named: DataManager.shared.getImageName(text))
    }
}

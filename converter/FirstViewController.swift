//
//  FirstViewController.swift
//  converter
//
//  Created by Andrei Shurykin on 10.02.22.
//

import UIKit

class FirstViewController: UIViewController {
    
    private var currentRate = 1.00
    private var firstCurrentCurrency = ""
    private var secondCurrentCurrency = ""
    
    private let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flag.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flag.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let firstTextField: UITextField = {
        let textField = UITextField()
        textField.roundCorners()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .green
        return textField
    }()
    
    private let secondTextField: UITextField = {
        let textField = UITextField()
        textField.roundCorners()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemTeal
        return textField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.backgroundColor = .gray
        button.setTitle("Tap to choose currencies", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        firstTextField.addTarget(self, action: #selector(firstTextFieldDidChange), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(secondTextFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    @objc private func buttonPressed(sender: UIButton) {
        let secondViewController = SecondViewController()
        secondViewController.secondViewControllerDelegate = self
        secondViewController.firstImageView.image = self.firstImageView.image
        secondViewController.secondImageView.image = self.secondImageView.image
        secondViewController.firstCurrentCurrency = self.firstCurrentCurrency
        secondViewController.secondCurrentCurrency = self.secondCurrentCurrency
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    private func setupViews() {
        self.view.addSubview(firstImageView)
        self.view.addSubview(secondImageView)
        self.view.addSubview(firstTextField)
        self.view.addSubview(secondTextField)
        self.view.addSubview(button)
        
        firstImageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        firstImageView.centerXAnchor.constraint(equalTo: firstTextField.centerXAnchor).isActive = true
        firstImageView.bottomAnchor.constraint(equalTo: firstTextField.topAnchor, constant: -10).isActive = true

        secondImageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        secondImageView.centerXAnchor.constraint(equalTo: secondTextField.centerXAnchor).isActive = true
        secondImageView.bottomAnchor.constraint(equalTo: secondTextField.topAnchor, constant: -10).isActive = true
        
        firstTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        firstTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2, constant: -15).isActive = true
        firstTextField.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        firstTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        secondTextField.leftAnchor.constraint(equalTo: firstTextField.rightAnchor, constant: 10).isActive = true
        secondTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        secondTextField.bottomAnchor.constraint(equalTo: firstTextField.bottomAnchor).isActive = true
        secondTextField.topAnchor.constraint(equalTo: firstTextField.topAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: firstTextField.widthAnchor).isActive = true
        button.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 10).isActive = true
        button.heightAnchor.constraint(equalTo: firstTextField.heightAnchor).isActive = true
    }
    
    @objc private func firstTextFieldDidChange() {
        secondTextField.text = DataManager.shared.convert(firstTextField.text, currentRate)
    }
    
    @objc private func secondTextFieldDidChange() {
        firstTextField.text = DataManager.shared.convert(secondTextField.text, (1 / currentRate))
    }
}

extension FirstViewController: SecondViewControllerDelegate {
    func setCurrentRate(_ value: Double) {
        currentRate = value
        DispatchQueue.main.async {
            self.firstTextFieldDidChange()
        }
        print(currentRate)
    }
    
    func setFirstCurrency(_ value: String) {
        firstCurrentCurrency = value
        firstImageView.image = UIImage(named: DataManager.shared.getImageName(firstCurrentCurrency))
    }
    
    func setSecondCurrency(_ value: String) {
        secondCurrentCurrency = value
        secondImageView.image = UIImage(named: DataManager.shared.getImageName(secondCurrentCurrency))
    }
}

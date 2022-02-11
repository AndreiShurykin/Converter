//
//  FirstViewController.swift
//  converter
//
//  Created by Andrei Shurykin on 10.02.22.
//

import UIKit

final class FirstViewController: UIViewController {
    
    let viewModel: FirstViewControllerViewModelProtocol
    
    private let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let firstTextField: UITextField = {
        let textField = UITextField()
        textField.roundCorners()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .green
        return textField
    }()
    private let secondTextField: UITextField = {
        let textField = UITextField()
        textField.roundCorners()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemTeal
        return textField
    }()
    private let firstButton: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Choose a currency", for: .normal)
        button.addTarget(self, action: #selector(firstButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        return button
    }()
    private let secondButton: UIButton = {
        let button = UIButton()
        button.roundCorners()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Choose a currency", for: .normal)
        button.addTarget(self, action: #selector(secondButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        return button
    }()
    
    private var currentRate = 1.0
    private var firstCurrentCurrency = ""
    private var secondCurrentCurrency = ""
    
    init(viewModel: FirstViewControllerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        firstTextField.addTarget(self, action: #selector(firstTextFieldDidChange(_:)), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(secondTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        var didFirstButtonTitleChange = false
        var didSecondButtonTitleChange = false
        if viewModel.isCurrencyChanged(firstButton.titleLabel?.text, secondButton.titleLabel?.text, firstCurrentCurrency, secondCurrentCurrency, { changes in
            didFirstButtonTitleChange = changes
        }, { changes in
            didSecondButtonTitleChange = changes
        }) {
            guard let firstText = firstButton.titleLabel?.text else {
                return
            }
            firstCurrentCurrency = firstText
            guard let secondText = secondButton.titleLabel?.text else {
                return
            }
            secondCurrentCurrency = secondText
            if viewModel.checkCurrencies(firstButton.titleLabel?.text, secondButton.titleLabel?.text) {
                DataManager.shared.getCurrencyRate(firstButton.titleLabel?.text, secondButton.titleLabel?.text) { result in
                    switch result {
                    case .success(let rate):
                        self.currentRate = rate
                        DispatchQueue.main.async {
                            if didFirstButtonTitleChange {
                                self.secondTextFieldDidChange(self.secondTextField)
                            } else if didSecondButtonTitleChange {
                                self.firstTextFieldDidChange(self.firstTextField)
                            }
                        }
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
    
    @objc private func firstTextFieldDidChange(_ textField: UITextField) {
        secondTextField.text = viewModel.convert(firstTextField.text, currentRate)
    }
    
    @objc private func secondTextFieldDidChange(_ textField: UITextField) {
        firstTextField.text = viewModel.convert(secondTextField.text, (1 / currentRate))
    }
    
    private func setupViews() {
        self.view.addSubview(firstImageView)
        self.view.addSubview(secondImageView)
        self.view.addSubview(firstTextField)
        self.view.addSubview(secondTextField)
        self.view.addSubview(firstButton)
        self.view.addSubview(secondButton)
        
        firstImageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        firstImageView.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor).isActive = true
        firstImageView.bottomAnchor.constraint(equalTo: firstButton.topAnchor).isActive = true

        secondImageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 7).isActive = true
        secondImageView.centerXAnchor.constraint(equalTo: secondButton.centerXAnchor).isActive = true
        secondImageView.bottomAnchor.constraint(equalTo: secondButton.topAnchor).isActive = true

        
        firstTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        firstTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2).isActive = true
        firstTextField.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 50).isActive = true
        firstTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        secondTextField.leftAnchor.constraint(equalTo: firstTextField.rightAnchor).isActive = true
        secondTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        secondTextField.bottomAnchor.constraint(equalTo: firstTextField.bottomAnchor).isActive = true
        secondTextField.topAnchor.constraint(equalTo: firstTextField.topAnchor).isActive = true
        
        firstButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        firstButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2).isActive = true
        firstButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.safeAreaLayoutGuide.layoutFrame.height / 5).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        secondButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2).isActive = true
        secondButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        secondButton.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor).isActive = true
        secondButton.topAnchor.constraint(equalTo: firstButton.topAnchor).isActive = true
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
    
    private func isCurrencyChanged() -> Bool {
        if firstButton.titleLabel?.text != firstCurrentCurrency {
            guard let text = firstButton.titleLabel?.text else {
                return false
            }
            firstCurrentCurrency = text
            return true
        } else if secondButton.titleLabel?.text != secondCurrentCurrency {
            guard let text = secondButton.titleLabel?.text else {
                return false
            }
            secondCurrentCurrency = text
            return true
        } else {
            return false
        }
    }
    
    private func updateImageView(_ button: UIButton,_ imageView: UIImageView) {
        guard let text = button.titleLabel?.text else {
            return
        }
        switch text {
        case byn:
            imageView.image = UIImage(named: "belarus")
        case eur:
            imageView.image = UIImage(named: "european-union.png")
        case rub:
            imageView.image = UIImage(named: "russia.png")
        case usd:
            imageView.image = UIImage(named: "united-states-of-america.png")
        default:
            print("Error")
        }
    }
}

//
//  StartAnimatedViewController.swift
//  Weather
//
//  Created by Максим Евграфов on 20.05.2023.
//

import UIKit

final class AnimationLogoViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var snowImage: UIImageView!
    
    @IBOutlet var appName: UILabel!
    @IBOutlet var univercityName: UILabel!
    @IBOutlet var madeByLabel: UILabel!
    @IBOutlet var authorName: UILabel!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showImage()
        showAppName()
        showAuthor()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // Создание градиентного слоя
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        // Определение цветов градиента
        let startColor = UIColor(
            red: 94 / 255,
            green: 104 / 255,
            blue: 131 / 255,
            alpha: 1.0
        ).cgColor
        
        let endColor = UIColor(
            red: 77 / 255,
            green: 20 / 255,
            blue: 117 / 255,
            alpha: 1.0
        ).cgColor
        gradientLayer.colors = [startColor, endColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(
            x: 1.0,
            y: 0.7
        )
        
        gradientLayer.type = .radial
        gradientLayer.locations = [0.1, 1]
        
        // Добавление градиентного слоя на главное представление
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func showImage() {
        let newSize = 150
        let newY: CGFloat = view.safeAreaInsets.top + 110
        let newX: CGFloat = (view.frame.width - CGFloat(newSize)) / 2
        
        UIView.animate(withDuration: 1.5) {
            self.snowImage.frame.origin = CGPoint(x: newX, y: newY)
            self.snowImage.frame.size = CGSize(width: newSize, height: newSize - 50)
        }
        
        UIView.animate(withDuration: 1.0, delay: 1.5, animations: {
            self.snowImage.frame.size = CGSize(width: newSize, height: newSize)
        }) { _ in
            self.performSegue(withIdentifier: "mainScreenSegue", sender: nil)
        }
    }
    
    private func showAppName() {
        UIView.animate(withDuration: 1.8, delay: 1.0) {
            self.appName.alpha = 1.0
            self.univercityName.alpha = 1.0
        }
    }
    
    private func showAuthor() {
        UIView.animate(withDuration: 1.0, delay: 1.8) {
            self.madeByLabel.alpha = 1.0
            self.authorName.alpha = 1.0
        }
    }
}

//
//  ViewController.swift
//  Weather
//
//  Created by Максим Евграфов on 07.05.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var propertiesBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getDataWeather()
    }
    
    @IBAction func refreshButtonDidTapped() {
        getDataWeather()
        print("Refresh button did tapped!")
    }
    
    private func setupUI() {
        refreshButton.backgroundColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0.3
        )
        refreshButton.layer.cornerRadius = 10
        refreshButton.tintColor = .white
        
        let colorTop =  UIColor(named: "propertiesBackgroundTop")!.cgColor
        let colorBottom = UIColor(named: "propertiesBackgroundBottom")!.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = propertiesBackgroundView.bounds
        
        propertiesBackgroundView.layer.insertSublayer(gradientLayer, at:0)
        propertiesBackgroundView.layer.sublayers?[0].cornerRadius = 10
        propertiesBackgroundView.layer.cornerRadius = 10
    }

    private func getDataWeather() {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let currentDate = dateFormatter.string(from: date as Date)
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let currentTime = dateFormatter.string(from: date as Date)
        dateTimeLabel.text = "\(currentDate) | \(currentTime)"
        
        guard let url = URL(
            string: "http://espservspbeu.mooo.com:10285"
        ) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    self.temperatureLabel.text = String(
                        format: "%.0f",
                        result.Temperature
                    )
                }
            } catch {
                print(error)
            }
            
        }.resume()
    }
}

struct Weather: Decodable {
    var Altitude: Double
    var Humidity: Double
    var Light: Double
    var Pressure: Double
    var Temperature: Double
}

//
//  ViewController.swift
//  Weather
//
//  Created by Максим Евграфов on 07.05.2023.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var dateTimeLabel: UILabel!
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var urlTextField: UITextField!
    
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    
    @IBOutlet var weatherImage: UIImage!
    
    @IBOutlet var propertiesBackgroundView: UIView!
    
    var url = "http://meteostationspbeu.mooo.com:10285"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getDataWeather()
    }
    
    @IBAction func refreshButtonDidTapped() {
        getDataWeather()
        print("Refresh button did tapped!")
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard let settingsVC = segue.source as? SettingsViewController else { return }
        url = settingsVC.urlTextField.text ?? "qwe"
        getDataWeather()
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
        
        settingsButton.backgroundColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 0.3
        )
        settingsButton.layer.cornerRadius = 10
        settingsButton.tintColor = .white
        
        let colorTop =  UIColor(named: "propertiesBackgroundTop")!.cgColor
        let colorBottom = UIColor(named: "propertiesBackgroundBottom")!.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = propertiesBackgroundView.bounds
        
//        propertiesBackgroundView.layer.insertSublayer(gradientLayer, at:0)
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
            string: url
        ) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Не получилось загрузить данные")
                }
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Weather.self, from: data)
                
                DispatchQueue.main.async {
                    self.setupValuesFor(weather: result)
                    self.changeImage(weather: result)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.showAlert(title: "Ошибка", message: "Не получилось загрузить данные")
                }
            }
            
        }.resume()
    }
    
    private func showAlert(title: String, message: String) {
        let alertForShow = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAlertButton = UIAlertAction(title: "Закрыть", style: .default)
        alertForShow.addAction(okAlertButton)
        
        self.present(alertForShow, animated: true)
    }
    
    private func setupValuesFor(weather: Weather) {
        temperatureLabel.text = String(
            format: "%.0f",
            weather.temperature
        )
        altitudeLabel.text = String(
            format: "%.f",
            weather.altitude
        ) + "%"
        humidityLabel.text = String(
            format: "%.f",
            weather.humidity
        ) + "%"
        pressureLabel.text = String(
            format: "%.f",
            weather.pressure
        )
    }
    
    private func changeImage(weather: Weather) {
        let currentDate = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: currentDate)
        
        //weatherImage
        if weather.light <= 15 || hour <= 4 || hour >= 22 {
            print("night")
            weatherLabel.text = "Ясно"
        } else if hour > 4, hour < 20, weather.light <= 70 {
            weatherLabel.text = "Дождь"
        } else if hour > 4, weather.light <= 250 {
            weatherLabel.text = "Облачно"
        } else {
            weatherLabel.text = "Ясно"
        }
    }
}

struct Weather: Decodable {
    var altitude: Double
    var humidity: Double
    var light: Double
    var pressure: Double
    var temperature: Double
}

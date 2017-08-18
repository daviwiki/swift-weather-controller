//
//  WeatherController.swift
//  Weather
//
//  Created by David Martinez on 11/08/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit
import DynamicColor

protocol WeatherControllerInput: NSObjectProtocol {
    
    func showError(message: String)
    func showWeather(weather: Weather.ViewModel)
    
}

protocol WeatherControllerOutput: NSObjectProtocol {
    
    func loadWeather(request: Weather.Request)
    
}

class WeatherController: UIViewController, WeatherControllerInput {
    
    var output: WeatherControllerOutput!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var hoursTableView: UITableView!
    
    fileprivate var gradientLayer: CAGradientLayer?
    fileprivate var weather: Weather.ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hoursTableView.estimatedRowHeight = 92
        hoursTableView.rowHeight = UITableViewAutomaticDimension
        
        let request = Weather.Request()
        output.loadWeather(request: request)
    }
    
    func showWeather(weather: Weather.ViewModel) {
        
        self.weather = weather
        
        configureDesign(weather: weather)
        hoursTableView.reloadData()
    }
    
    func showError(message: String) {
        // todo:
    }
}

extension WeatherController {
    
    fileprivate func configureDesign(weather: Weather.ViewModel) {
        
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = view.bounds
            gradientLayer?.startPoint = CGPoint(x: 0.6, y: 0.0)
            gradientLayer?.endPoint = CGPoint(x: 0.4, y: 1.0)
            view.layer.insertSublayer(gradientLayer!, at: 0)
        }
        
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        weatherStatusLabel.textColor = UIColor.white
        conditionsLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        
        if weather.mode == .light {
            light()
        } else {
            dark()
        }
    }
    
    private func dark() {
        
        // Gradient
        let startColor = UIColor(hexString: "383D87")
        let midColor = UIColor(hexString: "5F4E96")
        let endColor = UIColor(hexString: "D48CB4")
        
        gradientLayer?.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer?.locations = [0.0, 0.45, 0.75]
        
        // Titles
        locationLabel.textColor = startColor.darkened()
    }
    
    private func light() {
        
        // Gradient
        let startColor = UIColor(hexString: "D48CB4")
        let midColor = UIColor(hexString: "5F4E96")
        let endColor = UIColor(hexString: "383D87")
        
        gradientLayer?.colors = [startColor.cgColor, startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer?.locations = [0.0, 0.3, 0.75, 0.9]
        
        // Titles
        locationLabel.textColor = startColor.darkened()
        
        //        D48CB4 (rosa)
        //        222131 (negro)
        //        C97AA7 (rosa)
        //        5F4E96 (morado 1)
        //        383D87 (morado 2 - dark)
        //        A3699F (rosa 2 - dark)
        //        95537B (rosa 3 - dark+)
    }
}

extension WeatherController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weathercell", for: indexPath)
        return cell
    }
    
}

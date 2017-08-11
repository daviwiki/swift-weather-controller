//
//  WeatherController.swift
//  Weather
//
//  Created by David Martinez on 11/08/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

protocol WeatherControllerInput: NSObjectProtocol {
    
    func showError(message: String)
    func showWeather(weather: Weather.ViewModel)
    
}

protocol WeatherControllerOutput: NSObjectProtocol {
    
    func loadWeather(request: Weather.Request)
    
}

class WeatherController: UIViewController, WeatherControllerInput {
    
    var output: WeatherControllerOutput!
    var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = Weather.Request()
        output.loadWeather(request: request)
    }
    
    func showWeather(weather: Weather.ViewModel) {
        // todo:
    }
    
    func showError(message: String) {
        // todo:
    }
}


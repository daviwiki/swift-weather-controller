//
//  WeatherConfigurator.swift
//  Weather
//
//  Created by David Martinez on 11/08/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit

extension WeatherPresenter: WeatherControllerOutput {}
extension WeatherController: WeatherPresenterOutput {}

class WeatherConfigurator {
    
    enum WeatherError: Error {
        case layoutNotExist
    }
    
    static let `default` = WeatherConfigurator()
    
    func getWeatherController() throws -> WeatherController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "weather") as? WeatherController else {
            throw WeatherError.layoutNotExist
        }
        
        let presenter = WeatherPresenter()
        presenter.output = controller
        
        controller.output = presenter
        
        return controller
    }
    
}

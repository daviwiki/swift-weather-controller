//
//  WeatherPresenter.swift
//  Weather
//
//  Created by David Martinez on 11/08/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import Foundation

protocol WeatherPresenterInput {
    
    func loadWeather(request: Weather.Request)
    
}

protocol WeatherPresenterOutput {
    
    func showError(message: String)
    func showWeather(weather: Weather.ViewModel)
    
}

class WeatherPresenter: NSObject, WeatherPresenterInput {
    
    var output: WeatherPresenterOutput!
    
    func loadWeather(request: Weather.Request) {
        output.showWeather(weather: getFake())
    }
    
}

extension WeatherPresenter {
    
    fileprivate func getFake() -> Weather.ViewModel {
        var items: [Weather.ViewModel.WeatherHourItem] = []
                
        let item = Weather.ViewModel.WeatherHourItem(isFirst: true,
                                                     hour: "20:00",
                                                     iconName: "sun",
                                                     status: "Soleado",
                                                     temperature: "21ºC",
                                                     sentence: "Una tarde perfecta para ir a la playa")
        let item2 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "21:00",
                                                      iconName: "sun",
                                                      status: "Soleado",
                                                      temperature: "20ºC",
                                                      sentence: "Aprovecha estas últimas horas del día")
        let item3 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "22:12",
                                                      iconName: "nightfall",
                                                      status: "Anochece",
                                                      temperature: "18ºC",
                                                      sentence: "Podrías hacer una foto bonita al atardecer")
        let item4 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "23:00",
                                                      iconName: "moon_cloudy",
                                                      status: "Anochece",
                                                      temperature: "14ºC",
                                                      sentence: "Va a refrescar ... ¡Abrigate bien!")
        let item5 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "00:00",
                                                      iconName: "moon",
                                                      status: "Anochece",
                                                      temperature: "15ºC",
                                                      sentence: "Noche de perseidas, ¡Sal a admirar el cielo!")
        
        items.append(item)
        items.append(item2)
        items.append(item3)
        items.append(item4)
        items.append(item5)
        
        let weather = Weather.ViewModel(mode: .light,
                                        currentSky: "Soleado",
                                        currentStatus: "Brisa     20ºC",
                                        items: items)
        return weather
    }
}

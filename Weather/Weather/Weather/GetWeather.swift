
import Foundation
import Combine

protocol GetWeather {
    
    /**
     Return weather information
     */
    func weather() -> AnyPublisher<Weather.ViewModel, Error>
}

class GetWeatherDefault: GetWeather {
    
    func weather() -> AnyPublisher<Weather.ViewModel, Error> {
        Just(getFake())
            .setFailureType(to: Swift.Error.self)
            .eraseToAnyPublisher()
    }
}


private extension GetWeatherDefault {
    
    func getFake() -> Weather.ViewModel {
        var items: [Weather.ViewModel.WeatherHourItem] = []
                
        let item = Weather.ViewModel.WeatherHourItem(isFirst: true,
                                                     hour: "20:00",
                                                     iconName: Constants.WeatherIcons.Sunny.clear,
                                                     status: "Soleado",
                                                     temperature: "21ºC",
                                                     sentence: "Una tarde perfecta para ir a la playa")
        let item2 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "21:00",
                                                      iconName: Constants.WeatherIcons.Sunny.clear,
                                                      status: "Soleado",
                                                      temperature: "20ºC",
                                                      sentence: "Aprovecha estas últimas horas del día")
        let item3 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "22:12",
                                                      iconName: Constants.WeatherIcons.sunset,
                                                      status: "Anochece",
                                                      temperature: "18ºC",
                                                      sentence: "Podrías hacer una foto bonita al atardecer")
        let item4 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "23:00",
                                                      iconName: Constants.WeatherIcons.Moon.cloudy,
                                                      status: "Algunas nubes",
                                                      temperature: "14ºC",
                                                      sentence: "Va a refrescar ... ¡Abrigate bien!")
        let item5 = Weather.ViewModel.WeatherHourItem(isFirst: false,
                                                      hour: "00:00",
                                                      iconName: Constants.WeatherIcons.Moon.clear,
                                                      status: "Despejado",
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

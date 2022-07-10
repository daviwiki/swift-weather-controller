
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
        
        let getWeather = GetWeatherDefault()
        let presenter = WeatherPresenter(getWeather: getWeather)
        presenter.output = controller
        controller.output = presenter
        
        return controller
    }
    
}

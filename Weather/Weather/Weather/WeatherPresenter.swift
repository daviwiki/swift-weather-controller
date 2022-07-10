
import Foundation
import Combine

protocol WeatherPresenterInput {
    
    /**
     Load the weather information for the request given
     - parameter request: Request to be perform
     */
    func loadWeather(request: Weather.Request)
    
}

protocol WeatherPresenterOutput {
    
    /**
     Show an error if weather could not be load
     */
    func showError(message: String)
    
    /**
     Show weather given information
     */
    func showWeather(weather: Weather.ViewModel)
    
}

class WeatherPresenter: WeatherPresenterInput {
    
    var output: WeatherPresenterOutput!
    private let getWeather: GetWeather
    private var disposables: Set<AnyCancellable> = Set()
    
    init(getWeather: GetWeather) {
        self.getWeather = getWeather
    }
    
    func loadWeather(request: Weather.Request) {
        getWeather
            .weather()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.output.showError(message: "")
            } receiveValue: { [weak self] viewModel in
                self?.output.showWeather(weather: viewModel)
            }
            .store(in: &disposables)
    }
}



import Foundation

struct Weather {
    
    enum Mode {
        case light
        case dark
    }
    
    struct Request {
        
    }
    
    struct ViewModel {
        
        struct WeatherHourItem {
            
            let isFirst: Bool
            let hour: String
            let iconName: String
            let status: String
            let temperature: String
            let sentence: String
        }
        
        let mode: Mode
        let currentSky: String
        let currentStatus: String
        let items: [WeatherHourItem]
        
    }
    
}

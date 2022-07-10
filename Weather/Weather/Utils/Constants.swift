
import Foundation

struct Constants {
    
    struct ColorNames {
        
        static let primaryTextColor: String = "PrimaryText"
        static let secondaryTextColor: String = "SecondaryText"
        
        static let sunnyBgGradient: String = "SunnyGradient"
        static let midBgGradient: String = "MidGradient"
        static let nightBgGradient: String = "NightGradient"
    }
    
    struct WeatherIcons {
        
        static let sunrise = "sunrise.fill"
        static let sunset = "sunset.fill"
        
        struct Sunny {
            static let clear = "sun.max.fill"
            static let someClouds = "cloud.sun.fill"
            static let cloudy = "cloud.fill"
            static let dusty = "sun.dust.fill"
            static let haze = "sun.haze.fill"
            static let fog = "cloud.fog.fill"
            static let drizzleRain = "cloud.drizzle.fill"
            static let rainy = "cloud.rain.fill"
            static let heavyRain = "cloud.heavyrain.fill"
            static let stormy = "cloud.bolt.fill"
            static let stormAndRain = "cloud.bolt.rain.fill"
            static let hail = "cloud.hail.fill"
            static let snow = "cloud.snow.fill"
            static let wind = "wind"
            static let hurricane = "hurricane"
        }
        
        struct Moon {
            static let clear = "moon.fill"
            static let stars = "moon.stars.fill"
            static let cloudy = "cloud.moon.fill"
            static let rainy = "cloud.moon.rain.fill"
            static let storm = "cloud.moon.bolt.fill"
            static let haze = "cloud.haze.fill"
        }
    }
}

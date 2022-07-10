
import UIKit

extension String {
    
    var color: UIColor {
        return .init(named: self) ?? .white
    }
}

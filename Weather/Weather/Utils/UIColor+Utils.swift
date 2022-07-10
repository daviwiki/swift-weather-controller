
import UIKit

extension UIColor {
    
    func lighter(_ amount: CGFloat = 0.2) -> UIColor {
        changeBrightness(amount)
    }
    
    func darkened(_ amount: CGFloat = 0.2) -> UIColor {
        lighter(-1.0 * amount)
    }
    
    private func changeBrightness(_ amount: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b + amount, alpha: a)
    }
}

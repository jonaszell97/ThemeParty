
import SwiftUI

extension Color: Codable {
    /// The red, green, blue, and alpha components of this color.
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        #if canImport(UIKit)
        if #available(iOS 14.0, *) {
            guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
                return (0, 0, 0, 0)
            }
        } else {
            let components = self._components()
            let uiColor = UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
            guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &o) else {
                return (0, 0, 0, 0)
            }
        }
        #elseif canImport(AppKit)
        NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)
        #endif
        
        return (Double(r), Double(g), Double(b), Double(o))
    }
    
    fileprivate func _components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        let components = self.components
        
        try container.encode(components.red)
        try container.encode(components.green)
        try container.encode(components.blue)
        try container.encode(components.opacity)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let red = try container.decode(Double.self)
        let green = try container.decode(Double.self)
        let blue = try container.decode(Double.self)
        let opacity = try container.decode(Double.self)
        
        self = Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

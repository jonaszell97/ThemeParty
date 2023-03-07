
import SwiftUI

public struct AppTheme {
    /// The unique theme name.
    let name: String?
    
    /// The theme colors.
    let colors: [String: Color]
    
    /// Create a theme.
    public init(name: String?, colors colorNames: [String]) {
        self.name = name
        
        var colors = [String: Color]()
        if let name {
            for colorName in colorNames {
                colors[colorName] = Color("\(name)_\(colorName)")
            }
        }
        else {
            for colorName in colorNames {
                colors[colorName] = Color(colorName)
            }
        }
        
        self.colors = colors
    }
}

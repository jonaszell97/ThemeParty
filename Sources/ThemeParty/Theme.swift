
import SwiftUI

public struct AppTheme {
    /// The unique theme name.
    let name: String?
    
    /// Create a theme.
    public init(name: String?) {
        self.name = name
    }
    
    /// The name for a theme color.
    func color(for themedColor: ThemedColor) -> Color {
        switch themedColor {
        case .themed(let colorName):
            if let name {
                return Color("\(name)_\(colorName)")
            }
            
            return Color(colorName)
        case .fixed(let color):
            return color
        }
    }
}

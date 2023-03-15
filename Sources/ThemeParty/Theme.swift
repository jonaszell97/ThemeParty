
import SwiftUI

public struct AppTheme {
    /// The unique theme name.
    let name: String?
    
    /// Create a theme.
    public init(name: String?) {
        self.name = name
    }
    
    /// The name for a theme color.
    func color(named colorName: String) -> Color {
        if let name {
            return Color("\(name)_\(colorName)")
        }
        else {
            return Color(colorName)
        }
    }
}

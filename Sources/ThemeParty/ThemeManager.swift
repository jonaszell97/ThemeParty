
import SwiftUI

public final class ThemeManager: ObservableObject {
    /// The currently selected scheme.
    @Published var currentThemeData: (String?, Animation?)
    
    /// The registered themes.
    var themes: [String?: AppTheme]
    
    /// The fallback color to use for missing colors.
    let missingColor: Color
    
    /// The current theme name, or nil if the default theme is selected.
    public var currentTheme: String? { currentThemeData.0 }
    
    /// The current theme change animation.
    public var currentAnimation: Animation? { currentThemeData.1 }
    
    /// Create a theme manager.
    public init(missingColor: Color = .pink) {
        self.themes = [:]
        self.currentThemeData = (nil, nil)
        self.missingColor = missingColor
        
        self.registerTheme(name: nil)
    }
    
    /// Register a theme.
    public func registerTheme(name: String?) {
        self.themes[name] = .init(name: name)
    }
    
    /// Change the theme.
    public func changeTheme(name: String?, animation: Animation? = nil) {
        self.currentThemeData = (name, animation)
    }
    
    /// Get a color by name from the current theme.
    public func themeColor(named name: String) -> Color {
        self.themes[self.currentThemeData.0]?.color(for: .themed(name)) ?? missingColor
    }
    
    /// Get a color by name from the current theme.
    public func themeColor(for color: ThemedColor) -> Color {
        self.themes[self.currentThemeData.0]?.color(for: color) ?? missingColor
    }
    
    /// Create a clone of this theme manager.
    func clone(selectedTheme: String?) -> ThemeManager {
        let clone = ThemeManager(missingColor: self.missingColor)
        for (themeName, theme) in self.themes {
            clone.themes[themeName] = theme
        }
        
        clone.currentThemeData = (selectedTheme, nil)
        return clone
    }
}

struct ThemeManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeManager? = nil
}

public extension EnvironmentValues {
    var themeManager: ThemeManager? {
        get {
            return self[ThemeManagerEnvironmentKey.self]
        }
        set {
            self[ThemeManagerEnvironmentKey.self] = newValue
        }
    }
}

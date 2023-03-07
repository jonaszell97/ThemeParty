
import SwiftUI

public final class ThemeManager: ObservableObject {
    /// The currently selected scheme.
    @Published var currentScheme: AppTheme
    
    /// The registered themes.
    let themes: [String: AppTheme]
    
    /// The name of the default scheme.
    let defaultScheme: String
    
    /// Create a theme manager.
    public init(defaultScheme: AppTheme) {
        self.currentScheme = defaultScheme
        self.themes = [defaultScheme.name: defaultScheme]
        self.defaultScheme = defaultScheme.name
    }
    
    /// Get a color by name from the current theme.
    public func themeColor(named name: String) -> Color {
        currentScheme.colors[name] ?? .pink
    }
}

struct ThemeManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeManager? = nil
}

extension EnvironmentValues {
    var themeManager: ThemeManager? {
        get {
            return self[ThemeManagerEnvironmentKey.self]
        }
        set {
            self[ThemeManagerEnvironmentKey.self] = newValue
        }
    }
}

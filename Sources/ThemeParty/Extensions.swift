
import SwiftUI

public extension View {
    /// Apply a theme manager to a view hierarchy.
    func themed(by themeManager: ThemeManager) -> some View {
        self.environment(\.themeManager, themeManager)
    }
}

public struct ThemedContentView<Content: View>: View {
    /// The content view.
    let content: (ThemeManager?) -> Content
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(@ViewBuilder content: @escaping (ThemeManager?) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(themeManager)
    }
}

public struct ThemedBackgroundView<Content: View>: View {
    /// The name of the color.
    let colorName: String
    
    /// The content view.
    let content: Content
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(colorName: String, @ViewBuilder content: () -> Content) {
        self.colorName = colorName
        self.content = content()
    }
    
    public var body: some View {
        content.background(themeManager?.themeColor(named: self.colorName) ?? .pink)
    }
}

public struct ThemedForegroundColorView<Content: View>: View {
    /// The name of the color.
    let colorName: String
    
    /// The content view.
    let content: Content
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(colorName: String, @ViewBuilder content: () -> Content) {
        self.colorName = colorName
        self.content = content()
    }
    
    public var body: some View {
        content.foregroundColor(themeManager?.themeColor(named: self.colorName) ?? .pink)
    }
}

public struct ThemedShapeFillView<Content: Shape>: View {
    /// The name of the color.
    let colorName: String
    
    /// The content view.
    let content: Content
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(colorName: String, content: () -> Content) {
        self.colorName = colorName
        self.content = content()
    }
    
    public var body: some View {
        content.fill(themeManager?.themeColor(named: self.colorName) ?? .pink)
    }
}

public extension View {
    /// Apply a themed background color.
    func background(themedColor: String) -> some View {
        ThemedBackgroundView(colorName: themedColor) { self }
    }
    
    /// Apply a themed foreground color.
    func foreground(themedColor: String) -> some View {
        ThemedForegroundColorView(colorName: themedColor) { self }
    }
    
    /// Apply modifiers with a theme.
    func themed<Content: View>(@ViewBuilder content: @escaping (ThemeManager?) -> Content) -> some View {
        ThemedContentView(content: content)
    }
}

public extension Shape {
    /// Apply a themed fill color.
    func fill(themedColor: String) -> some View {
        ThemedShapeFillView(colorName: themedColor) { self }
    }
}


import SwiftUI

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
    
    /// The current background color.
    @State var backgroundColor: Color? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(colorName: String, @ViewBuilder content: () -> Content) {
        self.colorName = colorName
        self.content = content()
    }
    
    public var body: some View {
        content.background(backgroundColor)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.backgroundColor = themeManager!.themeColor(named: self.colorName)
                }
            }
    }
}

public struct ThemedForegroundColorView<Content: View>: View {
    /// The name of the color.
    let colorName: String
    
    /// The content view.
    let content: Content
    
    /// The current background color.
    @State var foregroundColor: Color? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(colorName: String, @ViewBuilder content: () -> Content) {
        self.colorName = colorName
        self.content = content()
    }
    
    public var body: some View {
        content.foregroundColor(foregroundColor)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.foregroundColor = themeManager!.themeColor(named: self.colorName)
                }
            }
    }
}

public struct ThemedShapeFillView<Content: Shape>: View {
    /// The name of the color.
    let colorName: String
    
    /// The content view.
    let content: Content
    
    /// The current fill color.
    @State var fillColor: Color? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(colorName: String, content: () -> Content) {
        self.colorName = colorName
        self.content = content()
    }
    
    public var body: some View {
        content.fill(fillColor ?? .clear)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.fillColor = themeManager!.themeColor(named: self.colorName)
                }
            }
    }
}

public extension View {
    /// Apply a theme manager to a view hierarchy.
    func themed(by themeManager: ThemeManager) -> some View {
        self.environment(\.themeManager, themeManager)
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

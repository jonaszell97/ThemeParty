
import SwiftUI

public struct ThemedContentView<Content: View>: View {
    /// The content view.
    let content: (String?, ThemeManager?) -> Content
    
    /// The current theme.
    @State var theme: String? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    public init(@ViewBuilder content: @escaping (String?, ThemeManager?) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content(theme, themeManager)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.theme = theme.0
                }
            }
    }
}

public struct StaticThemedContentView<Content: View>: View {
    /// The content view.
    let content: Content
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// The new theme manager.
    @State var clonedThemeManager: ThemeManager? = nil
    
    /// The theme to select.
    let selectedTheme: String?
    
    /// Create a themed background view.
    init(selectedTheme: String?, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.selectedTheme = selectedTheme
    }
    
    public var body: some View {
        content
            .themed(by: clonedThemeManager)
            .onAppear {
                self.clonedThemeManager = self.themeManager?.clone(selectedTheme: selectedTheme)
            }
    }
}

public struct ThemedBackgroundView<Content: View>: View {
    /// The themed color.
    let color: ThemedColor
    
    /// The content view.
    let content: Content
    
    /// The current background color.
    @State var backgroundColor: Color? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(color: ThemedColor, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }
    
    public var body: some View {
        content
            .background(backgroundColor)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.backgroundColor = themeManager!.themeColor(for: self.color)
                }
            }
    }
}

public struct ThemedForegroundColorView<Content: View>: View {
    /// The themed color.
    let color: ThemedColor
    
    /// The content view.
    let content: Content
    
    /// The current background color.
    @State var foregroundColor: Color? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(color: ThemedColor, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }
    
    public var body: some View {
        content.foregroundColor(foregroundColor)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.foregroundColor = themeManager!.themeColor(for: self.color)
                }
            }
    }
}

public struct ThemedShapeFillView<Content: Shape>: View {
    /// The themed color.
    let color: ThemedColor
    
    /// The content view.
    let content: Content
    
    /// The current fill color.
    @State var fillColor: Color? = nil
    
    /// The theme manager.
    @Environment(\.themeManager) var themeManager
    
    /// Create a themed background view.
    init(color: ThemedColor, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }
    
    public var body: some View {
        content.fill(fillColor ?? .clear)
            .onReceive(themeManager!.$currentThemeData) { theme in
                withAnimation(theme.1) {
                    self.fillColor = themeManager!.themeColor(for: self.color)
                }
            }
    }
}

public extension View {
    /// Apply a theme manager to a view hierarchy.
    func themed(by themeManager: ThemeManager?) -> some View {
        self.environment(\.themeManager, themeManager)
    }
    
    /// Apply a theme to this view hierarchy.
    func applyTheme(_ name: String) -> some View {
        StaticThemedContentView(selectedTheme: name) {
            self
        }
    }
}

public extension View {
    /// Apply a themed background color.
    func background(themedColor: String) -> some View {
        ThemedBackgroundView(color: .themed(themedColor)) { self }
    }
    
    /// Apply a themed foreground color.
    func foreground(themedColor: String) -> some View {
        ThemedForegroundColorView(color: .themed(themedColor)) { self }
    }
    
    /// Apply a themed background color.
    func background(themedColor: ThemedColor) -> some View {
        ThemedBackgroundView(color: themedColor) { self }
    }
    
    /// Apply a themed foreground color.
    func foreground(themedColor: ThemedColor) -> some View {
        ThemedForegroundColorView(color: themedColor) { self }
    }
    
    /// Apply modifiers with a theme.
    func themed<Content: View>(@ViewBuilder content: @escaping (String?, ThemeManager?) -> Content) -> some View {
        ThemedContentView(content: content)
    }
}

public extension Shape {
    /// Apply a themed fill color.
    func fill(themedColor: String) -> some View {
        ThemedShapeFillView(color: .themed(themedColor)) { self }
    }
    
    /// Apply a themed stroke color.
    func stroke(themedColor: String, style: StrokeStyle) -> some View {
        ThemedContentView { _, themeManager in
            self.stroke(themeManager?.themeColor(named: themedColor) ?? .pink, style: style)
        }
    }
    
    /// Apply a themed stroke color.
    func stroke(themedColor: String, lineWidth: CGFloat) -> some View {
        ThemedContentView { _, themeManager in
            self.stroke(themeManager?.themeColor(named: themedColor) ?? .pink, lineWidth: lineWidth)
        }
    }
    
    /// Apply a themed fill color.
    func fill(themedColor: ThemedColor) -> some View {
        ThemedShapeFillView(color: themedColor) { self }
    }
    
    /// Apply a themed stroke color.
    func stroke(themedColor: ThemedColor, style: StrokeStyle) -> some View {
        ThemedContentView { _, themeManager in
            self.stroke(themeManager?.themeColor(for: themedColor) ?? .pink, style: style)
        }
    }
    
    /// Apply a themed stroke color.
    func stroke(themedColor: ThemedColor, lineWidth: CGFloat) -> some View {
        ThemedContentView { _, themeManager in
            self.stroke(themeManager?.themeColor(for: themedColor) ?? .pink, lineWidth: lineWidth)
        }
    }
}

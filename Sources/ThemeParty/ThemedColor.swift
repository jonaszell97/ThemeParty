
import SwiftUI

public enum ThemedColor {
    /// A themed color with an explicit name.
    case themed(_ name: String)
    
    /// A fixed color.
    case fixed(_ color: Color)
}

public extension ThemedColor {
    /// The resolved color for this themed color.
    func resolvedColor(using themeManager: ThemeManager) -> Color {
        switch self {
        case .themed(let name):
            return themeManager.themeColor(named: name)
        case .fixed(let color):
            return color
        }
    }
}

extension ThemedColor: Codable {
    enum CodingKeys: String, CodingKey {
        case themed, fixed
    }
    
    var codingKey: CodingKeys {
        switch self {
        case .themed: return .themed
        case .fixed: return .fixed
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .themed(let name):
            try container.encode(name, forKey: .themed)
        case .fixed(let color):
            try container.encode(color, forKey: .fixed)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch container.allKeys.first {
        case .themed:
            let name = try container.decode(String.self, forKey: .themed)
            self = .themed(name)
        case .fixed:
            let color = try container.decode(Color.self, forKey: .fixed)
            self = .fixed(color)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
}

extension ThemedColor: Equatable {
    public static func ==(lhs: ThemedColor, rhs: ThemedColor) -> Bool {
        guard lhs.codingKey == rhs.codingKey else {
            return false
        }
        
        switch lhs {
        case .themed(let name):
            guard case .themed(let name_) = rhs else { return false }
            guard name == name_ else { return false }
        case .fixed(let color):
            guard case .fixed(let color_) = rhs else { return false }
            guard color == color_ else { return false }
            
        }
        
        return true
    }
}

extension ThemedColor: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.codingKey.rawValue)
        switch self {
        case .themed(let name):
            hasher.combine(name)
        case .fixed(let color):
            hasher.combine(color)
            
        }
    }
}


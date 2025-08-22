import Foundation

enum ImageEffect: String, CaseIterable {
    case original = "Original"
    case grayscale = "Grayscale"
    case sepia = "Sepia"
    case blur = "Blur"
    case vintage = "Vintage"
    case metal = "Metal"
    
    var iconName: String {
        switch self {
        case .original:
            return "photo"
        case .grayscale:
            return "circle.lefthalf.filled"
        case .sepia:
            return "sun.max"
        case .blur:
            return "aqi.medium"
        case .vintage:
            return "web.camera"
        case .metal:
            return "sparkles"
        }
    }
    
    var description: String {
        switch self {
        case .original:
            return "No effect applied"
        case .grayscale:
            return "Black and white filter"
        case .sepia:
            return "Warm brown tone"
        case .blur:
            return "Gaussian blur effect"
        case .vintage:
            return "Retro film look"
        case .metal:
            return "Metallic finish"
        }
    }
}

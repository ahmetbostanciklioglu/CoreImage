import SwiftUI

struct EffectButton: View {
    let effect: ImageEffect
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: effect.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .white : .primary)
                }
                
                Text(effect.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .blue : .primary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    HStack {
        EffectButton(effect: .grayscale, isSelected: false) { }
        EffectButton(effect: .sepia, isSelected: true) { }
        EffectButton(effect: .metal, isSelected: false) { }
    }
    .padding()
}
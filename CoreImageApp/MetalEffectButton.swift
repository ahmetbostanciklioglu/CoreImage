import SwiftUI

struct MetalEffectButton: View {
    let effect: MetalEffect
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.purple : Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: effect.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .white : .primary)
                }
                
                Text(effect.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .purple : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    HStack {
        MetalEffectButton(effect: .emboss, isSelected: false) { }
        MetalEffectButton(effect: .edgeDetection, isSelected: true) { }
        MetalEffectButton(effect: .pixelate, isSelected: false) { }
    }
    .padding()
}
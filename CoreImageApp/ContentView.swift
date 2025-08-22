import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedEffect: ImageEffect = .original
    @State private var selectedMetalEffect: MetalEffect?
    @State private var showingMetalEffects = false
    
    private let context = CIContext()
    private let metalProcessor = MetalImageProcessor()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    // Image Display Area
                    imageDisplayView
                    
                    // Effect Selection
                    if selectedImage != nil {
                        effectSelectionView
                        
                        // Metal Effects Toggle
                        metalEffectsToggle
                        
                        if showingMetalEffects {
                            metalEffectsView
                        }
                    }
                    
                    // Action Buttons
                    actionButtonsView
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Image Effects")
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
                }
                .sheet(isPresented: $showingCamera) {
                    ImagePicker(image: $selectedImage, sourceType: .camera)
                }
                .onChange(of: selectedImage) { _, newImage in
                    if let image = newImage {
                        resetEffects()
                        applyEffect(to: image)
                    }
                }
                .onChange(of: selectedEffect) { _, _ in
                    if let image = selectedImage {
                        selectedMetalEffect = nil
                        applyEffect(to: image)
                    }
                }
                .onChange(of: selectedMetalEffect) { _, effect in
                    if let image = selectedImage, let metalEffect = effect {
                        selectedEffect = .original
                        applyMetalEffect(to: image, effect: metalEffect)
                    }
                }
            }
        }
    }
    
    private var imageDisplayView: some View {
        ZStack {
            if let image = processedImage ?? selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxHeight: 360)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    )

                
                VStack(spacing: 12) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("Select an image to apply effects")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var effectSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Core Image Effects")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ImageEffect.allCases, id: \.self) { effect in
                        EffectButton(
                            effect: effect,
                            isSelected: selectedEffect == effect && selectedMetalEffect == nil
                        ) {
                            selectedEffect = effect
                            selectedMetalEffect = nil
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var metalEffectsToggle: some View {
        Button(action: {
            showingMetalEffects.toggle()
            if !showingMetalEffects {
                selectedMetalEffect = nil
                if let image = selectedImage {
                    applyEffect(to: image)
                }
            }
        }) {
            HStack {
                Image(systemName: "sparkles")
                Text("Metal Effects")
                Spacer()
                Image(systemName: showingMetalEffects ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .foregroundColor(.purple)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
    
    private var metalEffectsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metal Effects")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MetalEffect.allCases, id: \.self) { effect in
                        MetalEffectButton(
                            effect: effect,
                            isSelected: selectedMetalEffect == effect
                        ) {
                            selectedMetalEffect = effect
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var actionButtonsView: some View {
        HStack(spacing: 20) {
            Button(action: { showingImagePicker = true }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Gallery")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: { showingCamera = true }) {
                HStack {
                    Image(systemName: "camera")
                    Text("Camera")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private func resetEffects() {
        selectedEffect = .original
        selectedMetalEffect = nil
        showingMetalEffects = false
        processedImage = nil
    }
    
    private func applyEffect(to image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        
        let filteredImage: CIImage
        
        switch selectedEffect {
        case .original:
            filteredImage = ciImage
        case .grayscale:
            filteredImage = applyGrayscaleEffect(to: ciImage)
        case .sepia:
            filteredImage = applySepiaEffect(to: ciImage)
        case .blur:
            filteredImage = applyBlurEffect(to: ciImage)
        case .vintage:
            filteredImage = applyVintageEffect(to: ciImage)
        case .metal:
            filteredImage = applyMetalEffect(to: ciImage)
        }
        
        if let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) {
            processedImage = UIImage(cgImage: cgImage)
        }
    }
    
    private func applyMetalEffect(to image: UIImage, effect: MetalEffect) {
        guard let metalProcessor = metalProcessor else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let result = metalProcessor.processImage(image, with: effect)
            
            DispatchQueue.main.async {
                self.processedImage = result
            }
        }
    }
    
    private func applyGrayscaleEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter.colorMonochrome()
        filter.inputImage = image
        filter.color = CIColor.white
        filter.intensity = 1.0
        return filter.outputImage ?? image
    }
    
    private func applySepiaEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter.sepiaTone()
        filter.inputImage = image
        filter.intensity = 0.8
        return filter.outputImage ?? image
    }
    
    private func applyBlurEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = image
        filter.radius = 10.0
        return filter.outputImage ?? image
    }
    
    private func applyVintageEffect(to image: CIImage) -> CIImage {
        let sepiaFilter = CIFilter.sepiaTone()
        sepiaFilter.inputImage = image
        sepiaFilter.intensity = 0.5
        
        let vignetteFilter = CIFilter.vignette()
        vignetteFilter.inputImage = sepiaFilter.outputImage
        vignetteFilter.intensity = 0.3
        vignetteFilter.radius = 1.0
        
        return vignetteFilter.outputImage ?? image
    }
    
    private func applyMetalEffect(to image: CIImage) -> CIImage {
        let colorFilter = CIFilter.colorControls()
        colorFilter.inputImage = image
        colorFilter.saturation = 0.3
        colorFilter.brightness = 0.1
        colorFilter.contrast = 1.2
        
        let highlightFilter = CIFilter.highlightShadowAdjust()
        highlightFilter.inputImage = colorFilter.outputImage
        highlightFilter.highlightAmount = 0.8
        highlightFilter.shadowAmount = 0.2
        
        return highlightFilter.outputImage ?? image
    }
}

#Preview {
    ContentView()
}

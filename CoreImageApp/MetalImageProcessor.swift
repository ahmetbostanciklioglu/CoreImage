import Metal
import MetalKit
import CoreImage
import UIKit

class MetalImageProcessor {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let context: CIContext
    
    init?() {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        
        self.device = device
        self.commandQueue = commandQueue
        self.context = CIContext(mtlDevice: device)
    }
    
    func processImage(_ image: UIImage, with effect: MetalEffect) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let processedImage: CIImage
        
        switch effect {
        case .emboss:
            processedImage = applyEmbossEffect(to: ciImage)
        case .edgeDetection:
            processedImage = applyEdgeDetection(to: ciImage)
        case .pixelate:
            processedImage = applyPixelateEffect(to: ciImage)
        case .kaleidoscope:
            processedImage = applyKaleidoscopeEffect(to: ciImage)
        case .crystallize:
            processedImage = applyCrystallizeEffect(to: ciImage)
        }
        
        guard let cgImage = context.createCGImage(processedImage, from: processedImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func applyEmbossEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIConvolution3X3")!
        filter.setValue(image, forKey: kCIInputImageKey)
        
        // Emboss kernel
        let embossKernel = CIVector(values: [
            -2, -1, 0,
            -1, 1, 1,
            0, 1, 2
        ], count: 9)
        
        filter.setValue(embossKernel, forKey: "inputWeights")
        filter.setValue(0.5, forKey: "inputBias")
        
        return filter.outputImage ?? image
    }
    
    private func applyEdgeDetection(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIEdges")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(2.0, forKey: "inputIntensity")
        
        return filter.outputImage ?? image
    }
    
    private func applyPixelateEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIPixellate")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(12.0, forKey: "inputScale")
        
        return filter.outputImage ?? image
    }
    
    private func applyKaleidoscopeEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIKaleidoscope")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(6, forKey: "inputCount")
        filter.setValue(CIVector(x: image.extent.midX, y: image.extent.midY), forKey: "inputCenter")
        filter.setValue(0.0, forKey: "inputAngle")
        
        return filter.outputImage ?? image
    }
    
    private func applyCrystallizeEffect(to image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CICrystallize")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(20.0, forKey: "inputRadius")
        filter.setValue(CIVector(x: image.extent.midX, y: image.extent.midY), forKey: "inputCenter")
        
        return filter.outputImage ?? image
    }
}

enum MetalEffect: String, CaseIterable {
    case emboss = "Emboss"
    case edgeDetection = "Edge Detection"
    case pixelate = "Pixelate"
    case kaleidoscope = "Kaleidoscope"
    case crystallize = "Crystallize"
    
    var iconName: String {
        switch self {
        case .emboss:
            return "cube.transparent"
        case .edgeDetection:
            return "line.3.crossed.swirl.circle"
        case .pixelate:
            return "square.grid.3x3"
        case .kaleidoscope:
            return "scope"
        case .crystallize:
            return "diamond"
        }
    }
}

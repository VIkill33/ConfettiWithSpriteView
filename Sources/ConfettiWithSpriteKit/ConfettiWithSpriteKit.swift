// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import SpriteKit

@available(iOS 14, watchOS 6, visionOS 1, tvOS 1.3, *)

struct TransparentSpriteView: UIViewRepresentable {
    let scene: SKScene

    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: .zero)
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        
    }
}

struct ConfettiView: View {
    @State private var emitterScene: SKScene
    @State private var emitters: [SKEmitterNode]
    
    @Binding var start: Bool
    
    var angle: CGFloat
    var colors: [UIColor]
    var size: CGSize
    var scale: CGFloat
    var numToEmitRange: ClosedRange<Int>
    var images: [UIImage]

    init(
        start: Binding<Bool>,
        angle: CGFloat = CGFloat.pi / 2,
        colors: [UIColor] = [UIColor.red, .green, .systemTeal, .yellow, .orange, .purple],
        size: CGSize = CGSize(width: 25, height: 25),
        scale: CGFloat = 0.3,
        numToEmitRange: ClosedRange<Int> = 10...20,
        images: [UIImage] = [AMImage(named: "ribbon")!]
    ) {
        let scene = SKScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        scene.backgroundColor = .clear
        emitters = []
        self.emitterScene = scene
        _start = start
        self.angle = angle
        self.colors = colors
        self.size = size
        self.scale = scale
        self.numToEmitRange = numToEmitRange
        self.images = images
    }
    
    var body: some View {
        ZStack {
            TransparentSpriteView(scene: emitterScene)
            .ignoresSafeArea()
        }
        .onChange(of: start) { newValue in
            if newValue {
                createEmitter(angle: angle, colors: colors, size: size, scale: scale, numToEmitRange: numToEmitRange, images: images)
            } else {
                stopBirth()
            }
        }
    }
}

extension ConfettiView {
    func createEmitter(
        angle: CGFloat,
        colors: [UIColor],
        size: CGSize,
        scale: CGFloat,
        numToEmitRange: ClosedRange<Int>,
        images: [UIImage]
    ) {
        emitters.removeAll()
        for index in 0...colors.count-1 {
            let particleEmitter = SKEmitterNode()
            var particleImage: UIImage
            // 设置粒子发射器的属性
            if images.isEmpty {
                particleImage = AMImage(named: "ribbon")!
            } else {
                particleImage = images.randomElement()!
            }
            particleEmitter.particleTexture = SKTexture(image: particleImage)
            particleEmitter.particleColor = colors[index]
            particleEmitter.particleColorSequence = nil
            particleEmitter.particleBirthRate = 20 // 每秒发射20个粒子
            particleEmitter.numParticlesToEmit = .random(in: numToEmitRange)
            particleEmitter.particleLifetime = 5 // 粒子的生命周期为5秒
            particleEmitter.particlePosition = CGPoint(x: emitterScene.size.width / 2, y: emitterScene.size.height / 2) // 发射器的位置
            particleEmitter.emissionAngle = angle // 发射角度为90度
            particleEmitter.emissionAngleRange = CGFloat.pi / 2 // 发射角度范围
            particleEmitter.particleSpeed = 350 // 粒子速度
            particleEmitter.particleSpeedRange = 100 // 速度范围
            particleEmitter.yAcceleration = -400 // Y轴加速度
            particleEmitter.particleAlpha = 2.5 // 粒子的初始透明度
            particleEmitter.particleAlphaRange = 0.3 // 透明度范围
            particleEmitter.particleSize = size // 粒子的初始大小
            particleEmitter.particleScale = scale // 粒子的初始缩放
            particleEmitter.particleScaleRange = 0.2 // 缩放范围
            particleEmitter.particleRotationSpeed = .pi / 6 // 旋转速度
            particleEmitter.particleRotationRange = .pi * 2
            particleEmitter.particleColorBlendFactor = 1 // 颜色混合因子
            particleEmitter.particleBlendMode = .add // 混合模式
            emitters.append(particleEmitter)
        }
        for emitter in self.emitters {
            emitterScene.addChild(emitter)
        }
    }
    
    func stopBirth() {
        for emitter in self.emitters {
            emitter.particleBirthRate = 0
        }
    }
}

struct Confetti: ViewModifier {
    @Binding var start: Bool
    
    var angle: CGFloat = CGFloat.pi / 2
    var colors: [UIColor] = [UIColor.red, .green, .systemTeal, .yellow, .orange, .purple]
    var size: CGSize = CGSize(width: 25, height: 25)
    var scale: CGFloat = 0.3
    var numToEmitRange: ClosedRange<Int> = 10...20
    var images: [UIImage] = [AMImage(named: "ribbon")!]
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            ConfettiView(start: $start,
                         angle: angle,
                         colors: colors,
                         size: size, 
                         scale: scale,
                         numToEmitRange: numToEmitRange,
                         images: images)
                .contentShape(.circle)
                .allowsHitTesting(false)
        }
    }
}

extension View {
    /// Adds a confetti effect to the view hierarchy.
    ///
    /// - Parameters:
    ///   - start: A binding to a boolean value that controls the emission of confetti.
    ///   - angle: The angle at which the confetti will be emitted, measured in radians. Default is pi/2 (90 degrees).
    ///   - colors: An array of `UIColor` values representing the colors of the confetti. Default includes red, green, system teal, yellow, orange, and purple.
    ///   - size: The size of each confetti piece. Default is 25x25 points.
    ///   - scale: The initial scale of the confetti particles. Default is 0.3.
    ///   - numToEmitRange: A closed range of integers specifying the number of particles to emit. Default range is 10 to 20.
    ///   - images: An array of `UIImage` objects representing the images for the confetti. Default includes a ribbon image.
    /// - Returns: A view with the confetti effect applied.
    public func confetti(
        start: Binding<Bool>,
        angle: CGFloat = CGFloat.pi / 2,
        colors: [UIColor] = [UIColor.red, .green, .systemTeal, .yellow, .orange, .purple],
        size: CGSize = CGSize(width: 25, height: 25),
        scale: CGFloat = 0.3,
        numToEmitRange: ClosedRange<Int> = 10...20,
        images: [UIImage] = [AMImage(named: "ribbon")!]
    ) -> some View {
        self.modifier(Confetti(start: start, angle: angle, colors: colors, size: size, scale: scale, numToEmitRange: numToEmitRange, images: images))
    }
}

public func AMImage(named name: String) -> UIImage? {
    let image =  UIImage(named: name, in: Bundle.module, compatibleWith: nil)
    return image!
}

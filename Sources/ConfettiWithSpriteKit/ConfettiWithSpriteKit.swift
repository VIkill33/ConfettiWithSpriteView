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

    init(start: Binding<Bool>) {
        let scene = SKScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        scene.backgroundColor = .clear
        emitters = []
        self.emitterScene = scene
        _start = start
    }
    
    var body: some View {
        ZStack {
            TransparentSpriteView(scene: emitterScene)
            .ignoresSafeArea()
        }
        .onChange(of: start) { newValue in
            if newValue {
                createEmitter()
            } else {
                stopBirth()
            }
        }
    }
}

extension ConfettiView {
    func createEmitter() {
        emitters.removeAll()
        let colors = [UIColor.red, .green, .systemTeal, .yellow, .orange, .purple]
        for index in 1...10 {
            let particleEmitter = SKEmitterNode()

            // 设置粒子发射器的属性
            particleEmitter.particleTexture = SKTexture(image: AMImage(named: "ribbon")!) // 假设您有一个名为ribbon的图片作为粒子纹理
            particleEmitter.particleColor = colors[index % colors.count]
            particleEmitter.particleColorSequence = nil
            particleEmitter.particleBirthRate = 20 // 每秒发射20个粒子
            particleEmitter.numParticlesToEmit = .random(in: 5...15)
            particleEmitter.particleLifetime = 5 // 粒子的生命周期为5秒
            particleEmitter.particlePosition = CGPoint(x: emitterScene.size.width / 2, y: emitterScene.size.height / 2) // 发射器的位置
            particleEmitter.emissionAngle = CGFloat.pi / 2 // 发射角度为90度
            particleEmitter.emissionAngleRange = CGFloat.pi / 2 // 发射角度范围
            particleEmitter.particleSpeed = 350 // 粒子速度
            particleEmitter.particleSpeedRange = 100 // 速度范围
            particleEmitter.yAcceleration = -400 // Y轴加速度
            particleEmitter.particleAlpha = 2.5 // 粒子的初始透明度
            particleEmitter.particleAlphaRange = 0.3 // 透明度范围
            particleEmitter.particleSize = CGSize(width: 25, height: 25) // 粒子的初始大小
            particleEmitter.particleScale = 0.3 // 粒子的初始缩放
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
    public func body(content: Content) -> some View {
        ZStack {
            content
            ConfettiView(start: $start)
                .contentShape(.circle)
                .allowsHitTesting(false)
        }
    }
}

extension View {
    public func confetti(start: Binding<Bool>) -> some View {
        self.modifier(Confetti(start: start))
    }
}

public func AMImage(named name: String) -> UIImage? {
    let image =  UIImage(named: name, in: Bundle.module, compatibleWith: nil)
    return image!
}

# ConfettiWithSpriteView

A SwiftUI confetti modifier created by SpriteKit.
<p>
    <img src="https://img.shields.io/badge/iOS-14.0%2B-blue" />
    <img src="https://img.shields.io/badge/watchOS-6.0%2B-green" />
    <img src="https://img.shields.io/badge/visionOS-1.0%2B-red" />
    <img src="https://img.shields.io/badge/-SwiftUI-orange" />
</p>

- [Preview](#preview)
- [Installation](#installation)
- [Usage](#usage)
  * [Parameters](#parameters)
- [How does it work](#how_does_it_work)

## Preview
<img src="https://github.com/VIkill33/ConfettiWithSpriteView/assets/78488529/c4c32903-e5a4-4695-8834-6f5352c29ca6" width="200" height="433">

## Installation
In Xcode go to `File -> Swift Packages -> Add Package Dependency` 
and paste in the repo's url: 

`https://github.com/VIkill33/ConfettiWithSpriteView.git`

Or you can download the code of this repo, then `Add Local...` in Xcode, and open the folder of the repo.

## Usage
- Import this package after you installed by `import ConfettiWithSpriteKit`
- Use the modifier like(check it out in DemoAPP inside this package)
```swift
struct ContentView: View {
    
    @State private var startConfetti = false
    
    var body: some View {
        ZStack {
            Button("Start/Stop") {
                startConfetti.toggle()
            }
            .confetti(start: $startConfetti)
        }
    }
}
```
When you change the passed var `startConfetti` to `true`, confetti will play above your modified view(confetti will NOT handle touch events and will pass them to views underit), and `false` will stop emitting more confetti.

The var need to be changed to `false` then `true` to retrigger the confetti.

### Parameters
You can custom colors and images of confetti.

All descriptions about parameters were written in comment in source code:
```swift
    /// - Parameters:
    ///   - start: A binding to a boolean value that controls the emission of confetti.
    ///   - angle: The angle at which the confetti will be emitted, measured in radians. Default is pi/2 (90 degrees).
    ///   - colors: An array of `UIColor` values representing the colors of the confetti. Default includes red, green, system teal, yellow, orange, and purple.
    ///   - size: The size of each confetti piece. Default is 25x25 points.
    ///   - scale: The initial scale of the confetti particles. Default is 0.3.
    ///   - numToEmitRange: A closed range of integers specifying the number of particles to emit. Default range is 10 to 20.
    ///   - images: An array of `UIImage` objects representing the images for the confetti. Default includes a ribbon image.
```
## How does it work
It use `SKEmitterNode` in SpriteKit to emit particles, which are ribbons in this package defaultly. Particles of `SKEmitterNode` behave similarly to `CAEmitterLayer`'s. This repo is also an example about how to create SKEmitterNodes **programmaticaly**.

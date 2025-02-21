//
//  AnimatedGradientView.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import SwiftUI

struct AnimatingGradientView: View {
    @State var t: Float = 0.0
    @State var timer: Timer?

    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),

                .init(clampedSinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: t),
                      clampedSinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: t)),

                .init(clampedSinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: t),
                      clampedSinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: t)),

                .init(clampedSinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: t),
                      clampedSinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: t)),

                .init(clampedSinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: t),
                      clampedSinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: t)),

                .init(clampedSinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: t),
                      clampedSinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: t)),

                .init(clampedSinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: t),
                      clampedSinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: t))
            ],
            colors: [
                .red, .purple, .indigo,
                .orange, .blue, .green,
                .yellow, .mint, .black
            ]
        )
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    t += 0.05
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }

    func clampedSinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        let result = midPoint + amplitude * sin(timeScale * t + offset)

        return max(range.lowerBound + 0.1, min(range.upperBound - 0.1, result))
    }
}

#Preview {
    AnimatingGradientView()
}

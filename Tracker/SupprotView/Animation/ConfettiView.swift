import SwiftUI

struct ConfettiView: View {
    @State private var fireworks: [Firework] = []
    
    var body: some View {
        ZStack {
            ForEach(fireworks) { firework in
                FireworkExplosion(firework: firework)
            }
        }
        .onAppear {
            launchFireworks()
        }
    }
    
    private func launchFireworks() {
        // Запускаем 3 салюта с небольшой задержкой между ними
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                let firework = Firework(
                    position: CGPoint(
                        x: CGFloat.random(in: -100...100),
                        y: CGFloat.random(in: -200...(-50))
                    )
                )
                fireworks.append(firework)
            }
        }
    }
}

struct Firework: Identifiable {
    let id = UUID()
    let position: CGPoint
    let color: Color
    let particleCount: Int
    
    init(position: CGPoint) {
        self.position = position
        self.color = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .white].randomElement() ?? .red
        self.particleCount = Int.random(in: 40...60)
    }
}

struct FireworkExplosion: View {
    let firework: Firework
    @State private var isExploded = false
    
    var body: some View {
        ZStack {
            // Частицы салюта
            ForEach(0..<firework.particleCount, id: \.self) { index in
                FireworkParticle(
                    color: firework.color,
                    angle: Double(index) * (360.0 / Double(firework.particleCount)),
                    isExploded: $isExploded
                )
            }
        }
        .position(x: UIScreen.main.bounds.width / 2 + firework.position.x,
                 y: UIScreen.main.bounds.height / 2 + firework.position.y)
        .onAppear {
            withAnimation(.easeOut(duration: 0.1)) {
                isExploded = true
            }
        }
    }
}

struct FireworkParticle: View {
    let color: Color
    let angle: Double
    @Binding var isExploded: Bool
    
    let speed = CGFloat.random(in: 100...200)
    let scale = CGFloat.random(in: 0.5...1.5)
    let shape = FireworkShape.allCases.randomElement() ?? .circle
    
    // Добавляем вариацию в цвет
    var particleColor: Color {
        let brightness = Double.random(in: 0.7...1.3)
        return color.opacity(brightness > 1 ? 1 : brightness)
    }
    
    var body: some View {
        Group {
            switch shape {
            case .circle:
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [particleColor, particleColor.opacity(0.6)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 5
                        )
                    )
                    .frame(width: 10, height: 10)
            case .star:
                Star()
                    .fill(particleColor)
                    .frame(width: 12, height: 12)
            case .diamond:
                Diamond()
                    .fill(particleColor)
                    .frame(width: 8, height: 8)
            case .sparkle:
                Sparkle()
                    .fill(particleColor)
                    .frame(width: 10, height: 10)
            }
        }
        .scaleEffect(isExploded ? scale : 0.1)
        .offset(
            x: isExploded ? cos(angle * .pi / 180) * speed : 0,
            y: isExploded ? sin(angle * .pi / 180) * speed + (isExploded ? 100 : 0) : 0
        )
        .opacity(isExploded ? 0 : 1)
        .rotationEffect(.degrees(isExploded ? angle * 2 : 0))
        .animation(
            .easeOut(duration: Double.random(in: 1.0...1.8))
            .delay(Double.random(in: 0...0.1)),
            value: isExploded
        )
        // Добавляем эффект мерцания
        .shadow(color: particleColor.opacity(0.8), radius: isExploded ? 0 : 4)
    }
}

enum ConfettiShape: CaseIterable {
    case circle
    case square
    case triangle
    case star
}

struct ConfettiPiece: View {
    let color: Color
    let shape: ConfettiShape
    @Binding var animate: Bool
    
    let startX = CGFloat.random(in: -20...20)
    let startY = CGFloat.random(in: -50...0)
    let endY = CGFloat.random(in: 300...500)
    let duration = Double.random(in: 1.0...2.0)
    let rotation = Double.random(in: 0...1080)
    let scale = CGFloat.random(in: 0.4...1.2)
    
    var body: some View {
        Group {
            switch shape {
            case .circle:
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            case .square:
                Rectangle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            case .triangle:
                Triangle()
                    .fill(color)
                    .frame(width: 10, height: 10)
            case .star:
                Star()
                    .fill(color)
                    .frame(width: 12, height: 12)
            }
        }
        .scaleEffect(scale)
        .offset(x: animate ? startX * 10 : startX, 
               y: animate ? endY : startY)
        .rotationEffect(.degrees(animate ? rotation : 0))
        .opacity(animate ? 0 : 1)
        .animation(.easeOut(duration: duration), value: animate)
    }
}

enum FireworkShape: CaseIterable {
    case circle
    case star
    case diamond
    case sparkle
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let numberOfPoints = 5
        
        for i in 0..<numberOfPoints * 2 {
            let angle = (Double(i) * .pi) / Double(numberOfPoints) - .pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct Sparkle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Создаем крестообразную искру
        // Вертикальная линия
        path.move(to: CGPoint(x: center.x, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
        
        // Горизонтальная линия
        path.move(to: CGPoint(x: center.x - radius, y: center.y))
        path.addLine(to: CGPoint(x: center.x + radius, y: center.y))
        
        // Диагональные линии
        let diagRadius = radius * 0.7
        path.move(to: CGPoint(x: center.x - diagRadius, y: center.y - diagRadius))
        path.addLine(to: CGPoint(x: center.x + diagRadius, y: center.y + diagRadius))
        
        path.move(to: CGPoint(x: center.x + diagRadius, y: center.y - diagRadius))
        path.addLine(to: CGPoint(x: center.x - diagRadius, y: center.y + diagRadius))
        
        return path.strokedPath(.init(lineWidth: 2, lineCap: .round))
    }
}

struct ConfettiModifier: ViewModifier {
    @Binding var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isActive {
                        ConfettiView()
                            .allowsHitTesting(false)
                    }
                }
            )
    }
}

extension View {
    func confetti(isActive: Binding<Bool>) -> some View {
        modifier(ConfettiModifier(isActive: isActive))
    }
}

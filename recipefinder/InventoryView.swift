import SwiftUI

struct InventoryView: View {
    @State private var scrollOffset: CGFloat = 0

    let contentWidth: CGFloat = 600
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
      
    ]
    
    let columns2 = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
      
    ]

    let items = Array(1...10)
    let items2 = Array(1...6)

    var body: some View {
        GeometryReader { outerGeo in
            let screenWidth = outerGeo.size.width

            ZStack() {

                ScrollView(.horizontal, showsIndicators: true) {
                    
                    ZStack {
                        
                        
                        Image("fridgeMain")
                            .resizable()
                            .scaledToFill()
                        //.scaledToFit()
                            .frame(width: contentWidth)
                            .clipped()
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: ScrollOffsetKey.self,
                                            value: geo.frame(in: .global).minX
                                        )
                                }
                            )
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            
                            ForEach(items, id: \.self) { item in
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.green.opacity(0.25))
                                    .frame(height: 40)
                                    .frame(width: 100)
                                    .overlay {
                                        Text("\(item)")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                            }
                        }
                        .fixedSize()
                        .position(x: 165, y: 400)
                        
                        
                        LazyVGrid(columns: columns, spacing: 50) {
                            
                            ForEach(items2, id: \.self) { item in
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.green.opacity(0.35))
                                    .frame(height: 40)
                                    .frame(width: 100)
                                    .overlay {
                                        Text("\(item)")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                            }
                        }
                        .fixedSize()
                        .position(x: 430, y: 400)
                        .rotation3DEffect(Angle(degrees: 10), axis: (0.50,-0.25,1.0))
                        
                     
                    }
                }
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = -value
                }
                
               
                
               
                
            }
            ZStack {
                ProgressView(value: progress(screenWidth: screenWidth))
                    .progressViewStyle(.linear)
                    .scaleEffect(x: 1, y: 5)
                    .tint(.orange.opacity(0.6))
                    .padding(.horizontal, 50)
                Text("Please scroll horizontally")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .background(.yellow.opacity(0.25))
    }

    // Progress calculation
    func progress(screenWidth: CGFloat) -> CGFloat {
        let maxScroll = contentWidth - screenWidth
        guard maxScroll > 0 else { return 0 }
        return min(max(scrollOffset / maxScroll, 0), 1)
    }
}

// PreferenceKey
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

#Preview {
    InventoryView()
}

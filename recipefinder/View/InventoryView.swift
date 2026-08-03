import SwiftUI

struct InventoryView: View {
    @State private var viewModel = InventoryViewModel()
    
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack(spacing: 0) {
            
            GeometryReader { outerGeo in
                let screenWidth = outerGeo.size.width
                ZStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                        ZStack {
                            Image("fridgeMain")
                                .resizable()
                                .scaledToFill()
                                .frame(width: viewModel.contentWidth)
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
                            
                            LazyVGrid(columns: viewModel.columns, spacing: 16) {
                                ForEach(viewModel.fridgeSlots) { slot in
                                    RoundedRectangle(cornerRadius: 16)
                                    
                                        .fill(slot.itemName != nil ? Color.orange.opacity(0.80) : Color.green.opacity(0.00))
                                    
                                        .frame(height: 40)
                                        .frame(width: 100)
                                    
                                        .overlay {
                                            if slot.itemName != nil {
                                                Image(systemName: "carrot")
                                                    .font(.title2.bold())
                                                    .foregroundColor(.white)
                                                
                                                Image(systemName: "info.circle")
                                                    .tooltip(slot.itemName ?? "Empty slot")
                                                    .frame(width: 25, height: 25)
                                                    .scaleEffect(1.25)
                                                    .foregroundStyle(Color.white)
                                                    .position(x: 85, y: 5)
                                                    .onTapGesture {
                                                        viewModel.infoTapped(for: slot)
                                                    }
                                            } else {
                                                Text("\(slot.id)")
                                                    .font(.title)
                                                    .foregroundColor(.black.opacity(0.85))
                                            }
                                        }
                                }
                            }
                            .fixedSize()
                            .position(x: 165, y: 400)
                            
                            LazyVGrid(columns: viewModel.columns, spacing: 50) {
                                ForEach(viewModel.items2, id: \.self) { item in
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
                            .rotation3DEffect(Angle(degrees: 10), axis: (0.50, -0.25, 1.0))
                        }
                    }
                    .onPreferenceChange(ScrollOffsetKey.self) { value in
                        viewModel.updateScrollOffset(value)
                    }
                    
                    Image(systemName: "plus.square.fill")
                        .scaleEffect(3)
                        .position(x: outerGeo.size.width * 0.80, y: outerGeo.size.height * 0.90)
                        .foregroundStyle(Color.orange.opacity(0.85))
                        .onTapGesture {
                            viewModel.openAddItemsSheet()
                        }
                }
                
                ZStack {
                    ProgressView(value: viewModel.progress(screenWidth: screenWidth))
                        .progressViewStyle(.linear)
                        .scaleEffect(x: 1, y: 5)
                        .tint(.orange.opacity(0.6))
                        .padding(.horizontal, 50)
                    Text("Please scroll horizontally")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if !viewModel.fridgeItems.isEmpty {
                SelectedItemsChipRow(
                    items: viewModel.fridgeItems,
                    onRemove: viewModel.removeItem
                )
                .padding(.horizontal)
            }
        }
        .background(.yellow.opacity(0.20))
        .sheet(isPresented: $vm.showAddItemsSheet) {
            AddFridgeItemsSheet(viewModel: viewModel)
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

#Preview {
    InventoryView()
}

//
//  HorizontalRouletteView.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//

import SwiftUI

struct HorizontalRouletteView<Item>: View where Item: RoulettableItem {

    @State private var selectedIndex: Int = 0
    
    private let itemWidth: CGFloat
    private let items: [Item]
    
    private var onSelected: ((Item) -> Void)?
    
    init(itemWidth: CGFloat = 100, items: [Item]) {
        self.itemWidth = itemWidth
        self.items = items
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                Spacer().frame(width: itemWidth)
                
                LazyHStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        rowItem(
                            item: items[index],
                            isSelected: index == selectedIndex)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                
                Spacer().frame(width: itemWidth)
            }
            .onScrollTargetVisibilityChange(idType: Int.self) { ids in
                let selectedIndex = ids.first ?? 0
                self.selectedIndex = selectedIndex
                
                onSelected?(items[selectedIndex])
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                if newPhase == .idle {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        // Snap to selected index
                        proxy.scrollTo(selectedIndex, anchor: .center)
                    }
                }
            }
            .frame(width: itemWidth)
        }
    }
}

extension HorizontalRouletteView {
    func onSelected(_ action: @escaping (Item) -> Void) -> Self {
        var copy = self
        copy.onSelected = action
        return copy
    }
}

private extension HorizontalRouletteView {
    func rowItem(item: Item, isSelected: Bool) -> some View {
        Text(item.description)
            .frame(width: itemWidth)
            .frame(maxHeight: .infinity)
            .font(.title2)
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .opacity(isSelected ? 1.0 : 0.5)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

//
//  HorizontalRouletteView.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//

import SwiftUI

struct HorizontalRouletteView<Item>: View where Item: RoulettableViewItem {

    @State private var selectedIndex: Int = 0
    
    private let itemWidth: CGFloat
    private let items: [Item]
    private let numberOfDisplayedItem: Int
    
    private var onSelected: ((Item) -> Void)?
    
    init(itemWidth: CGFloat = 100, items: [Item], numberOfDisplayedItem: Int = 3) {
        self.itemWidth = itemWidth
        self.items = items
        self.numberOfDisplayedItem = numberOfDisplayedItem
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    Spacer().frame(width: itemWidth)
                    
                    ForEach(items.indices, id: \.self) { index in
                        rowItem(
                            item: items[index],
                            index: index,
                            isSelected: index == selectedIndex)
                        .id(index)
                    }
                    
                    Spacer().frame(width: itemWidth)
                }
                .scrollTargetLayout()
            }
            .onScrollTargetVisibilityChange(idType: Int.self) { ids in
                let selectedIndex = if ids.contains(0), ids.count < numberOfDisplayedItem {
                    0
                } else {
                    ids.center ?? 0
                }
                
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
            .frame(width: itemWidth * CGFloat(numberOfDisplayedItem))
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
    var filler: some View {
        Spacer().frame(width: itemWidth)
    }
    
    func rowItem(item: Item, index: Int, isSelected: Bool) -> some View {
        return item.content(index: index, isSelected: isSelected)
            .frame(width: itemWidth)
            .frame(maxWidth: .infinity)
    }
}

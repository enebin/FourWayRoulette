//
//  VerticalRouletteView.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//

import SwiftUI

struct VerticalRouletteView<Item>: View where Item: RoulettableItem {
    
    @State private var selectedIndex: Int = 0
    
    private let itemHeight: CGFloat
    private let items: [Item]
    private var onSelected: ((Item) -> Void)?
    
    init(itemHeight: CGFloat = 40, items: [Item]) {
        self.itemHeight = itemHeight
        self.items = items
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                Spacer().frame(height: itemHeight)
                
                LazyVStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        rowItem(
                            item: items[index],
                            isSelected: index == selectedIndex)
                        .onTapGesture {
                            withAnimation(scrollAnimation) {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                
                Spacer().frame(height: itemHeight)
            }
            .onScrollTargetVisibilityChange(idType: Int.self) { ids in
                let selectedIndex = ids.second ?? 0
                self.selectedIndex = selectedIndex
                
                onSelected?(items[selectedIndex])
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                // Snap to selected index
                if newPhase == .idle {
                    withAnimation(scrollAnimation) {
                        proxy.scrollTo(selectedIndex, anchor: .center)
                    }
                }
            }
            .frame(height: itemHeight * 3)
        }
    }
}

extension VerticalRouletteView {
    func onSelected(_ action: @escaping (Item) -> Void) -> Self {
        var copy = self
        copy.onSelected = action
        return copy
    }
}

private extension VerticalRouletteView {
    var scrollAnimation: Animation {
        .easeInOut(duration: 0.1)
    }
    
    func rowItem(item: Item, isSelected: Bool) -> some View {
        Text(item.description)
            .frame(height: itemHeight)
            .frame(maxWidth: .infinity)
            .font(.title2)
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .opacity(isSelected ? 1.0 : 0.5)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

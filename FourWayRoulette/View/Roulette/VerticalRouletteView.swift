//
//  VerticalRouletteView.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//

import SwiftUI

struct VerticalRouletteView<Item>: View where Item: RoulettableViewItem {
    
    @State private var selectedIndex: Int = 0
    @State private var isCurrentIndexLongPressed = false
    @State private var task: Task<Void, Never>? = nil

    private let itemHeight: CGFloat
    private let items: [Item]
    private let numberOfDisplayedItem: Int
    
    private var onSelected: ((Item) -> Void)?
    
    init(itemHeight: CGFloat = 40, items: [Item], numberOfDisplayedItem: Int = 3) {
        self.itemHeight = itemHeight
        self.items = items
        self.numberOfDisplayedItem = numberOfDisplayedItem
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                Spacer().frame(height: itemHeight)
                
                LazyVStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack {
                            if index == selectedIndex && isCurrentIndexLongPressed {
                                rowItem(
                                    item: items[index],
                                    index: index,
                                    isSelected: index == selectedIndex)
                                
                                HorizontalRouletteView(items: [
                                    ContentView.Item(description: "Long Pressed"),
                                    ContentView.Item(description: "Long Pressed"),
                                    ContentView.Item(description: "Long Pressed"),
                                    ContentView.Item(description: "Long Pressed"),
                                    ContentView.Item(description: "Long Pressed"),
                                    ContentView.Item(description: "Long Pressed")
                                ])
                                .frame(height: itemHeight)
                            } else {
                                rowItem(
                                    item: items[index],
                                    index: index,
                                    isSelected: index == selectedIndex)
                            }
                        }
                        .onTapGesture {
                            withAnimation(scrollAnimation) {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                        .onLongPressGesture {
                            if index != selectedIndex {
                                withAnimation(scrollAnimation) {
                                    proxy.scrollTo(index, anchor: .center)
                                }
                            }
                            isCurrentIndexLongPressed = true
                        }
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                
                Spacer().frame(height: itemHeight)
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
                // Snap to selected index
                if newPhase == .idle {
                    withAnimation(scrollAnimation) {
                        proxy.scrollTo(selectedIndex, anchor: .center)
                    }
                    startDelayedAction()
                } else if newPhase == .interacting {
                    isCurrentIndexLongPressed = false
                    cancelTask()
                }
            }
            .frame(height: isCurrentIndexLongPressed ? itemHeight * 4 : itemHeight * 3)
            .animation(.spring(duration: 0.2), value: isCurrentIndexLongPressed)
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
    
    func rowItem(item: Item, index: Int, isSelected: Bool) -> some View {
        return item.content(index: index, isSelected: isSelected)
            .frame(height: itemHeight)
            .frame(maxWidth: .infinity)
    }
    
    func startDelayedAction() {
        // Cancel any existing task
        task?.cancel()

        task = Task {
            do {
                try await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else {
                    isCurrentIndexLongPressed = true
                    return
                }
                isCurrentIndexLongPressed = true
            } catch {
                isCurrentIndexLongPressed = false
            }
        }
    }

    func cancelTask() {
        task?.cancel()
    }
}

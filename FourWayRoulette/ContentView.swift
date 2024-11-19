//
//  ContentView.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FourWayRouletteView(
            items: (0..<50).map { _ in VerticalItem() }
        )
        .onSelected { item in
            print(item)
        }
    }
    
    struct Item: RoulettableItem {
        let id = UUID()
        let description: String
    }
    
    struct VerticalItem: VerticalViewItem {
        let id = UUID()
        let horizontalItems: [HorizontalViewItem] = [
            HorizontalViewItem(),
            HorizontalViewItem(),
            HorizontalViewItem(),
            HorizontalViewItem(),
            HorizontalViewItem()
        ]
        
        func content(index: Int, isSelected: Bool) -> some View {
            HStack {
                Image(systemName: "person")
                Text("Item \(index)")
                    .font(.caption)
            }
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .opacity(isSelected ? 1.0 : 0.5)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
        }
    }
    
    struct HorizontalViewItem: RoulettableViewItem {
        let id = UUID()
        
        func content(index: Int, isSelected: Bool) -> some View {
            Text("Item \(index)")
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .opacity(isSelected ? 1.0 : 0.5)
                .animation(.easeInOut(duration: 0.1), value: isSelected)
        }
    }
}

#Preview {
    ContentView()
}

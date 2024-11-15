//
//  ContentView.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VerticalRouletteView(
            items: (0..<50).map { Item(description: "Item \($0)") }
        )
        .onSelected { item in
            print(item)
        }
    }
    
    struct Item: RoulettableItem {
        let id = UUID()
        let description: String
    }
}

#Preview {
    ContentView()
}

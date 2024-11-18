//
//  RoulettableItem.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//

protocol RoulettableItem: Identifiable {
    var description: String { get }
}

import SwiftUI
protocol RoulettableViewItem: Identifiable {
    associatedtype Content: View
//    var content: (Int) -> Content { get } // equal to `(itemIndex) -> some View`
    func content(index: Int, isSelected: Bool) -> Content
}

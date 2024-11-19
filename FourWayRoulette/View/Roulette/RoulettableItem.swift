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
    
    func content(index: Int, isSelected: Bool) -> Content
}

protocol VerticalViewItem: RoulettableViewItem {
    associatedtype HorizontalItem: RoulettableViewItem

    var horizontalItems: [HorizontalItem] { get }
}

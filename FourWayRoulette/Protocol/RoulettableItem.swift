//
//  RoulettableItem.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//

import SwiftUI
protocol RoulettableViewItem: Identifiable {
    associatedtype Content: View
    
    func content(index: Int, isSelected: Bool) -> Content
}

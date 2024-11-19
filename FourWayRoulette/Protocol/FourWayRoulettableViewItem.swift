//
//  FourWayRoulettableViewItem.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/19/24.
//



protocol FourWayRoulettableViewItem: RoulettableViewItem {
    associatedtype HorizontalItem: RoulettableViewItem

    var horizontalItems: [HorizontalItem] { get }
}

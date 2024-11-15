//
//  Array+.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//



extension Array {
    var second: Element? {
        guard count > 1 else { return nil }
        return self[1]
    }
}

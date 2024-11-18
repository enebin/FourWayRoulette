//
//  Array+.swift
//  FourWayRoulette
//
//  Created by Kai Lee on 11/15/24.
//



extension Array {
    var center: Element? {
        guard !isEmpty else {
            return nil
        }
        
        guard count > 1 else {
            return self[0]
        }
        
        let centerIndex = Int(count / 2)
        return self[centerIndex]
    }
    
    var second: Element? {
        guard count > 1 else { return nil }
        return self[1]
    }
}

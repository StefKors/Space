//
//  Clamp.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import Foundation

extension Comparable {
    func clamped(_ f: Self, _ t: Self)  ->  Self {
        var r = self
        if r < f { r = f }
        if r > t { r = t }
        // (use SIMPLE, EXPLICIT code here to make it utterly clear
        // whether we are inclusive, what form of equality, etc etc)
        return r
    }
}

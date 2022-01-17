//
//  FloatingPointNotation.swift
//  UsefulExtensions
//
//  Created by Josef Zoller on 16.01.22.
//

public enum FloatingPointNotation {
    case decimal
    case scientific
    case shortest
    
    
    var printfSpecifier: String {
        switch self {
        case .decimal:
            return "f"
        case .scientific:
            return "e"
        case .shortest:
            return "g"
        }
    }
}

//
//  Formatter.swift
//  UsefulExtensions
//
//  Created by Josef Zoller on 16.01.22.
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif


public protocol Formatter {
    associatedtype Value
    
    func string(from value: Value) -> String
}


public struct DefaultIntegerFormatter<Value>: Formatter where Value: BinaryInteger {
    let radix: Int
    let minimumWidth: Int
    let paddingCharacter: PaddingCharacter
    let forceSign: Bool
    let uppercaseLetters: Bool
    
    public init(withRadix radix: Int, minimumWidth: Int = 0, paddingCharacter: PaddingCharacter = .space, forceSign: Bool = false, uppercaseLetters: Bool = false) {
        self.radix = radix
        self.minimumWidth = minimumWidth
        self.paddingCharacter = paddingCharacter
        self.forceSign = forceSign
        self.uppercaseLetters = uppercaseLetters
    }
    
    public init(withMinimumWidth minimumWidth: Int, paddingCharacter: PaddingCharacter = .space, forceSign: Bool = true) {
        self.radix = 10
        self.minimumWidth = minimumWidth
        self.paddingCharacter = paddingCharacter
        self.forceSign = forceSign
        self.uppercaseLetters = false
    }
    
    public func string(from value: Value) -> String {
        let isNegative = value < 0
        
        let valueString = String(value.magnitude, radix: self.radix, uppercase: self.uppercaseLetters)
        
        let paddingLength: Int
        let signString: String
        if self.forceSign || isNegative {
            paddingLength = self.minimumWidth - valueString.count - 1
            signString = isNegative ? "-" : "+"
        } else {
            paddingLength = self.minimumWidth - valueString.count
            signString = ""
        }
        
        let paddingString: String
        if paddingLength > 0 {
            paddingString = String(repeating: self.paddingCharacter.rawValue, count: paddingLength)
        } else {
            paddingString = ""
        }
        
        switch self.paddingCharacter {
        case .space:
            return paddingString + signString + valueString
        default:
            return signString + paddingString + valueString
        }
    }
}

#if canImport(Darwin) || canImport(Glibc)
public struct DefaultFloatingPointFormatter<Value>: Formatter where Value: BinaryFloatingPoint, Value: CVarArg {
    let precision: Int
    let minimumWidth: Int
    let paddingCharacter: PaddingCharacter
    let forceSign: Bool
    let notation: FloatingPointNotation
    
    public init(withPrecision precision: Int, minimumWidth: Int = 0, paddingCharacter: PaddingCharacter = .space, forceSign: Bool = false, notation: FloatingPointNotation = .decimal) {
        precondition(precision > 0)
        
        self.precision = precision
        self.minimumWidth = minimumWidth
        self.paddingCharacter = paddingCharacter
        self.forceSign = forceSign
        self.notation = notation
    }
    
    public func string(from value: Value) -> String {
        let isNegative = value < 0
        
        guard value.isFinite else {
            if value.isNaN {
                return "nan"
            } else {
                return isNegative ? "-inf" : "inf"
            }
        }
        
        let value = value.magnitude
        
        var buffer = UnsafeMutablePointer<CChar>.allocate(capacity: 32)
        defer { buffer.deallocate() }
        
        var length = Int(snprintf(ptr: buffer, 32, "%.\(self.precision)\(self.notation.printfSpecifier)", value))
        
        if length < 0 {
            return (isNegative ? "-" : "") + "\(value)"
        } else if length >= 32 {
            buffer.deallocate()
            buffer = UnsafeMutablePointer<CChar>.allocate(capacity: length + 1)
            
            length = Int(snprintf(ptr: buffer, length + 1, "%.\(self.precision)\(self.notation.printfSpecifier)", value))
        }
        
        let valueString = String(cString: buffer)
        
        let paddingLength: Int
        let signString: String
        if self.forceSign || isNegative {
            paddingLength = self.minimumWidth - length - 1
            signString = isNegative ? "-" : "+"
        } else {
            paddingLength = self.minimumWidth - length
            signString = ""
        }
        
        let paddingString: String
        if paddingLength > 0 {
            paddingString = String(repeating: self.paddingCharacter.rawValue, count: paddingLength)
        } else {
            paddingString = ""
        }
        
        switch self.paddingCharacter {
        case .space:
            return paddingString + signString + valueString
        default:
            return signString + paddingString + valueString
        }
    }
}
#endif

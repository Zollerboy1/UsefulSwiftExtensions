//
//  StringInterpolation+NumberFormatting.swift
//  UsefulExtensions
//
//  Created by Josef Zoller on 16.01.22.
//

extension StringInterpolationProtocol where StringLiteralType == String {
    public mutating func appendInterpolation<Value>(_ value: Value, radix: Int, uppercaseLetters: Bool = false) where Value: BinaryInteger {
        let formatter = DefaultIntegerFormatter<Value>(withRadix: radix, uppercaseLetters: uppercaseLetters)
        
        self.appendInterpolation(value, formattedUsing: formatter)
    }
    
    public mutating func appendInterpolation<Value>(_ value: Value, paddedToWidth minimumWidth: Int, using paddingCharacter: PaddingCharacter = .space, forceSign: Bool = false) where Value: BinaryInteger {
        let formatter = DefaultIntegerFormatter<Value>(withMinimumWidth: minimumWidth, paddingCharacter: paddingCharacter, forceSign: forceSign)
        
        self.appendInterpolation(value, formattedUsing: formatter)
    }
    
#if canImport(Darwin) || canImport(Glibc)
    public mutating func appendInterpolation<Value>(_ value: Value, precision: Int, minimumWidth: Int = 0, paddingCharacter: PaddingCharacter = .space, forceSign: Bool = false, notation: FloatingPointNotation = .decimal) where Value: BinaryFloatingPoint, Value: CVarArg {
        let formatter = DefaultFloatingPointFormatter<Value>(withPrecision: precision, minimumWidth: minimumWidth, paddingCharacter: paddingCharacter, forceSign: forceSign, notation: notation)
        
        self.appendInterpolation(value, formattedUsing: formatter)
    }
#endif
    
    public mutating func appendInterpolation<Value, F>(_ value: Value, formattedUsing formatter: F) where F: Formatter, F.Value == Value {
        appendLiteral(formatter.string(from: value))
    }
}

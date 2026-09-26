//
//  UInt8.swift
//  AirAP
//
//  Created by neon443 on 26/09/2026.
//

import Foundation

extension UInt8 {
	init?(hex string: String) {
		var int: UInt8 = 0
		guard string.count == 2 else { return nil }
		if let first = string.first,
		   let hexDigit = HexadecimalDigit(char: first) {
			int += hexDigit.rawValue * 16
		}
		if let last = string.last,
		   let hexDigit = HexadecimalDigit(char: last) {
			int += hexDigit.rawValue
		}
		self = int
	}
	
	func hex() -> String {
		let lhs = self/16
		let rhs = self-(lhs*16)
		return HexadecimalDigit(rawValue: lhs)!.description + HexadecimalDigit(rawValue: rhs)!.description
	}
}

struct HexadecimalDigit {
	var rawValue: UInt8
	static var validCharacters: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
	
	var description: String {
		if self.rawValue >= 0 && self.rawValue <= 9 {
			return "\(self.rawValue)"
		} else if self.rawValue >= 10 && self.rawValue <= 15 {
			return String(Character(UnicodeScalar(65 + (Int(self.rawValue)-10))!))
		} else {
			return "X"
		}
	}
	
	init?(char: Character) {
		if let int = UInt8(String(char)),
		   int >= 0 && int <= 15 {
			rawValue = int
		} else if let asciiValue = char.asciiValue,
				  asciiValue >= 65 && asciiValue <= 70 {
			rawValue = asciiValue-55
		} else if let asciiValue = char.asciiValue,
				  asciiValue >= 97 && asciiValue <= 102 {
			rawValue = asciiValue-87
		} else {
			return nil
		}
	}
	
	init?(rawValue: UInt8) {
		guard rawValue >= 0 && rawValue <= 15 else { return nil }
		self.rawValue = rawValue
	}
}

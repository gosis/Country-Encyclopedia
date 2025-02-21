//
//  Utilities.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation

class Utilities {
    public static func flagEmoji(from countryCode: String) -> String {
        let base: UInt32 = 127397
        var emoji = ""
        
        for scalar in countryCode.uppercased().unicodeScalars {
            if let scalarValue = UnicodeScalar(base + scalar.value) {
                emoji.append(String(scalarValue))
            }
        }
        
        return emoji
    }
}

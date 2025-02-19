//
//  Item.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 18/02/2025.
//

import Foundation
import SwiftData

@Model
final class FavoriteCountry {
    var cca3: String
    
    init(cca3: String) {
        self.cca3 = cca3
    }
}

//
//  PopulationActor.swift
//  Country Encyclopedia
//
//  Created by Gints Osis on 19/02/2025.
//

import Foundation

actor PopulationActor {
    
    public var populationDict = [String: Int]()
    
    init(countries: [Country]) {
        var populationArray = [(name:String, population: Int)]()
        
        for country in countries {
            populationArray.append((name: country.name.common, population: country.population))
        }
        
        populationArray.sort { $0.population > $1.population }
        var tempPopulationDict = [String: Int]()
        for (index, data) in populationArray.enumerated() {
            tempPopulationDict[data.name] = index + 1
        }
        self.populationDict = tempPopulationDict
    }
}

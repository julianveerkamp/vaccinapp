//
//  CountrySelection.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//

import SwiftUI

struct RecommendationSettings: View {
    @AppStorage("selectedCountry") var selectedCountry: Country = .germany
    
    var body: some View {
        Form {
            Picker("Country", selection: $selectedCountry) {
                ForEach(Country.allCases, id: \.hashValue) { country in
                    HStack {
                        Text(country.emoji)
                        Text(country.rawValue.capitalized)
                    }
                    .tag(country)
                }
                .navigationTitle("Country")
            }
        }
        .navigationTitle("Recommendations")
    }
}

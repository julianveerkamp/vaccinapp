//
//  ContentView.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 14.04.22.
//

import SwiftUI
import CoreData
import Combine
import os

struct Recommendations: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("selectedCountry") var selectedCountry = Country.germany
    @StateObject var c = RecommendationsNetworkController()
    @ObservedObject var defaultPass: DefaultPass
    
    var body: some View {
        NavigationView {
            if let pass = defaultPass.pass {
                RecommendationList(for: pass)
                    .navigationTitle("Recommendations")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink{
                                RecommendationSettings()
                            } label: {
                                Text(selectedCountry.emoji)
                                    .font(.system(size: 28))
                            }
                            
                        }
                    }
                    .onAppear {
                        c.get(for: selectedCountry)
                        viewContext.refreshAllObjects()
                    }
            } else {
                Text("Please create/select a Pass first.")
                    .fontWeight(.semibold)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.systemGray4))
                    .padding()
                    .padding([.bottom], 50)
            }
            
        }
    }
}

struct RecommendationList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("selectedCountry") var selectedCountry: Country = .germany
    
    @FetchRequest private var recommendations: FetchedResults<DiseaseTarget>
    @ObservedObject var selectedPass: VaccinationPass
    
    var filteredRecommendations: [DiseaseTarget] {
        recommendations.filter({filter($0, pass: self.selectedPass)})
    }
    
    init(for pass: VaccinationPass) {
        _recommendations = FetchRequest(fetchRequest: DiseaseTarget.allRecommendedTargets(for: pass))
        selectedPass = pass
    }
    
    var body: some View {
        Group {
            if filteredRecommendations.count == 0 {
                Text("No Recommendations\n🎉")
                    .fontWeight(.semibold)
                    .font(.system(size: 30))
                    .lineSpacing(20)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.systemGray4))
                    .padding()
                    .padding([.bottom], 50)
            } else {
                List(filteredRecommendations) { (target: DiseaseTarget) in
                    Section {
                        if let recommendation = target.recommendation {
                            Text(recommendation.text)
                                .padding(5)
                                .padding([.vertical], 5)
                            
                            Countrylist(countries: recommendation.wrappedCountries)
                        }
                    }
                }
            }
        }
    }
    
    func filter(_ item: DiseaseTarget, pass: VaccinationPass) -> Bool {
        var result = true
        
        for vaccination in item.wrappedVaccinations {
            if vaccination.valid && vaccination.pass == pass {
                result = false
            }
        }
        if let countries = item.recommendation?.countries {
            if !countries.contains(selectedCountry.rawValue.lowercased()) && selectedCountry != .all {
                result = false
            }
        }
        
        return result
    }
}

struct Countrylist: View {
    @State var countries: [Country]
    
    init(countries: [Country]) {
        if countries.count == 0 {
            self.countries = [.all]
        } else {
            self.countries = countries
        }
    }
    
    var body: some View {
        HStack{
            Text("Affected Countries:")
                .fontWeight(.semibold)
            ForEach(countries, id: \.hashValue) { country in
                Menu {
                    Text(country.rawValue.capitalized)
                } label: {
                    Text(country.emoji)
                }
            }
        }
        
    }
}

struct Countrylist_Previews: PreviewProvider {
    static var previews: some View {
        Countrylist(countries: [.germany,.greece,.thailand])
    }
}

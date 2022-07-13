//
//  Settings.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//

import SwiftUI

struct Settings: View {
    @State var selection: String?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("Pass Overview") {PassList()}
                    NavigationLink("Export") {Export()}
                    NavigationLink("Recommendations") {RecommendationSettings()}
                }
                Section{
                    NavigationLink("Licenses") {Licenses()}
                    NavigationLink("Privacy Policy") {PrivacyPolicy()}
                }
            }
            .navigationTitle("Settings")
        }
    }
}

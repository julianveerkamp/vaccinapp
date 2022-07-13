//
//  PassView.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//

import Foundation
import SwiftUI

struct PassView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VaccinationPass.name, ascending: true)],
        animation: .default)
    private var passes: FetchedResults<VaccinationPass>
    
    @ObservedObject var defaultPass: DefaultPass
    @State private var name = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            VaccinationList(controller: VaccinationListController(pass: defaultPass.pass))
                .navigationTitle(defaultPass.pass?.name ?? "No Pass")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            ForEach(passes) { pass in
                                Button {
                                    selectPass(pass)
                                } label: {
                                    Text("\(pass.wrappedType.emoji)   \(pass.name)")
                                }
                            }
                        } label: {
                            Label("Pass Menu", systemImage: "person.crop.rectangle.stack.fill")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            if let pass = defaultPass.pass {
                                AddVaccination(pass: pass, showAlert: $isShowingAlert)
                            } else {
                                AddPassWrapper()
                            }
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("Duplicate Vaccination"),
                        message: Text("A Vaccination Entry for the selected Disease Target exists already.")
                    )
                }
        }
    }
    
    func selectPass(_ pass: VaccinationPass) {
        print("Selected Pass: \(pass.name)")
        defaultPass.selectNewPass(pass, in: context)
    }
}


//
//  PassDetail.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.07.22.
//

import Foundation
import SwiftUI

struct PassDetail: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @StateObject var item: VaccinationPass
    @State var name = ""
    
    init(_ pass: VaccinationPass) {
        self._item = StateObject(wrappedValue: pass)
        self.name = pass.name
    }
    
    var body: some View {
        Form {
            TextField("Name", text: $item.name)
            
            Picker("Gennder", selection: $item.wrappedGender) {
                Text("Female").tag(Gender.female)
                Text("None").tag(Gender.none)
                Text("Male").tag(Gender.male)
            }.pickerStyle(SegmentedPickerStyle())
            
            DatePicker("Date of Birth", selection: $item.dob, displayedComponents: [.date])
        }
        .navigationTitle(item.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    do {
                        try context.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                        context.rollback()
                    }
                }
            }
        }
    }
}

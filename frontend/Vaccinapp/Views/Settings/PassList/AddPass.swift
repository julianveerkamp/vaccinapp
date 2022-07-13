//
//  AddPass.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.07.22.
//

import Foundation
import SwiftUI

struct AddPassWrapper: View {
    @State var name = ""
    @State var gender = Gender.none
    @State var dob = Date.now
    @State var type: PassType? = PassType.human
    
    @StateObject var defaultPass: DefaultPass
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest = DefaultPass.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        if let pass = try? context.fetch(fetchRequest).first {
            self._defaultPass = StateObject(wrappedValue: pass)
        } else {
            self._defaultPass = StateObject(wrappedValue: DefaultPass(context: context))
            try? context.save()
        }
    }
    
    var body: some View {
        Form {
            AddPass(name: $name, gender: $gender, dob: $dob, type: $type, defaultPass: defaultPass)
        }
    }
}

struct AddPass: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var name: String
    @Binding var gender: Gender
    @Binding var dob: Date
    @Binding var type: PassType?
    @State var readPolicy = false
    
    @ObservedObject var defaultPass: DefaultPass
    
    @State var isShowingError = false
    
    var disableFinish: Bool {
        if type == nil {
            return !(name.count != 0 && readPolicy)
        } else {
            return name.count == 0
        }
    }
    
    var body: some View {
        Section {
            HStack {
                Image(systemName: "highlighter")
                TextField("Name", text: $name)
            }
            
            Picker("Gender", selection: $gender) {
                Text("Female").tag(Gender.female)
                Text("None").tag(Gender.none)
                Text("Male").tag(Gender.male)
            }.pickerStyle(SegmentedPickerStyle())
            
            DatePicker("Date of Birth", selection: $dob, displayedComponents: [.date])
            
            if type != nil {
                Picker("Type", selection: $type) {
                    ForEach(PassType.allCases, id: \.hashValue) { type in
                        Text("\(type.emoji)   \(type.rawValue.capitalized)").tag(type as PassType?)
                    }
                }
            } else {
                HStack {
                    Button {
                        readPolicy.toggle()
                    } label: {
                        Image(systemName: readPolicy ? "checkmark.square.fill" : "square")
                            .foregroundColor(readPolicy ? .mint : .primary)
                        Text("Agree to the Privacy Policy")
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
            }
        }
        
        Section {
            Button {
                addPass()
            } label: {
                Text("Finish")
                    .fontWeight(.bold)
            }.disabled(disableFinish)
        }
        .alert(isPresented: $isShowingError) {
            Alert(title: Text("Error"), message: Text("Pass with the same name exists already"))
        }
    }
    
    func addPass() {
        let newPass = VaccinationPass(context: viewContext)
        newPass.name = name
        newPass.wrappedGender = gender
        newPass.dob = dob
        newPass.wrappedType = type ?? .human
        
        do {
            try viewContext.save()
            print("Pass saved succesfully")
            defaultPass.selectNewPass(newPass, in: viewContext)
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
        } catch {
            viewContext.rollback()
            print("Failed to save: \(error)")
            isShowingError = true
        }
        presentationMode.wrappedValue.dismiss()
    }
}

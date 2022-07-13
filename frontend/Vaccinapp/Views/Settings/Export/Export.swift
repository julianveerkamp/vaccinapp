//
//  Export.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//

import SwiftUI
import CryptoKit


struct Export: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @State private var selectedPass: VaccinationPass?
    @State private var password: String = ""
    @State private var showImporter = false
    @State private var showExportView = true
    @State private var selectedFile: URL?
    @State private var isShowingError = false
    @State private var errorString = ""
    
    var key: SymmetricKey {
        let padded = password.padding(toLength: 32, withPad: "-", startingAt: 0)
        
        return SymmetricKey(data: padded.data(using: String.Encoding.utf8)!)
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VaccinationPass.name, ascending: true)],
        animation: .default)
    private var passes: FetchedResults<VaccinationPass>
    
    var body: some View {
        Form {
            Picker("Select Export or Import View", selection: $showExportView) {
                Text("Export").tag(true)
                Text("Import").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .listRowBackground(Color.clear)
            
            if showExportView {
                exportView.navigationTitle("Export")
            } else {
                importView.navigationTitle("Import")
            }
            
            if isShowingError {
                Text(errorString)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.data]) { result in
            if case .success = result {
                do {
                    let result = try result.get()
                    
                    selectedFile = result
                    
                } catch {
                    let nsError = error as NSError
                    print(nsError)
                }
            } else {
                print("File Import Failed")
            }
        }
    }
    
    var exportView: some View {
        Group {
            Section {
                Picker("Pass to export", selection: $selectedPass) {
                    List(passes) { (pass: VaccinationPass) in
                        Text(pass.name).tag(pass as VaccinationPass?)
                    }
                }
                TextField("Password", text: $password)
            }
            Button("Export") {
                export()
            }
        }
    }
    
    var importView: some View {
        Group {
            Section{
                Button {
                    showImporter = true
                } label: {
                    HStack {
                        Text("Select File")
                        Spacer()
                        Text(selectedFile?.lastPathComponent ?? "")
                            .foregroundColor(Color(.systemGray))
                    }
                }
                TextField("Password", text: $password)
            }
            Button("Import") {
                importPass()
            }
        }
    }
    
    func importPass() {
        do {
            let porter = Porter()
            
            let importedPass = try porter.importPass(try Data(contentsOf: selectedFile!), key: key, context: context)
            
            for v in importedPass.wrappedVaccines {
                print(v.target!.name)
            }
            try context.save()
        } catch {
            errorString = "Error importing pass, check your password."
            isShowingError = true
            print(error)
            context.rollback()
        }
    }
    
    func export() {
        do {
            guard let passToExport = selectedPass else { throw ExportError.exportE }
            
            let porter = Porter()
            let url = try porter.exportPass(passToExport, key: key)
            
            //       Share as file
            let AV = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            
            windowScene?.keyWindow?.rootViewController?.present(AV, animated: true, completion: nil)
            
            
        } catch ExportError.exportE {
            errorString = "Error exporting your Pass, try again."
            isShowingError = true
        } catch {
            print(error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

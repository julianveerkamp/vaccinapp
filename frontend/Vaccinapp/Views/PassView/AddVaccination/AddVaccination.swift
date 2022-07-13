//
//  AddVaccination.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 02.05.22.
//

import Foundation
import SwiftUI
import CodeScanner
import base45_swift
import Compression
import SwiftCBOR
import CoreData


enum ScannerError: Error {
    case certificateExists
    case decodingIssue
    case unsupportedPayload
    case wrongTarget
}

struct AddVaccination: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest
    private var diseases: FetchedResults<DiseaseTarget>
    
    @Binding var showAlertAfterError: Bool
    
    @State private var isShowingScanner = false
    @State private var isShowingAlert = false
    @State private var diseaseSelection: DiseaseTarget?
    @State private var vaccineSelection: Vaccine?
    @State private var timestamp: Date = Date.now
    @State private var manufacturer = ""
    @State private var certificates = [ExtendedCBORWebToken]()
    @State public var pass: VaccinationPass
    @State private var vaccineSelectionDisabled: Bool = true
    
    private var correctForm: Bool {
        diseaseSelection != nil && vaccineSelection != nil
    }
    
    init(pass: VaccinationPass, showAlert: Binding<Bool>) {
        let request = FetchRequest<DiseaseTarget>(
            entity: DiseaseTarget.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "%K == %@", #keyPath(DiseaseTarget.type), pass.type)
        )
        _diseases = request
        _diseaseSelection = State(initialValue: nil)
        _vaccineSelection = State(initialValue: nil)
        _pass = State(initialValue: pass)
        _showAlertAfterError = showAlert
    }
    
    var body: some View {
        Form {
            Section {
                let b = Binding(
                    get: { self.diseaseSelection },
                    set: {
                        self.diseaseSelection = $0
                        vaccineSelection = nil
                    }
                )
                Picker("Disease name", selection: b) {
                    List(diseases) { (d: DiseaseTarget) in
                        Text(d.name).tag(d as DiseaseTarget?)
                    }
                }
                
                DatePicker("Date of Vaccination", selection: $timestamp, displayedComponents: [.date])
                
                Picker("Vaccine", selection: $vaccineSelection) {
                    List(diseaseSelection?.wrappedVaccines ?? []) { (d: Vaccine) in
                        Text(d.name).tag(d as Vaccine?)
                    }
                }.disabled(diseaseSelection == nil)
                HStack {
                    Text("Manufacturer")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(vaccineSelection?.manufacturer ?? "")
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Button(action: {isShowingScanner = true}) {
                    Label("Scan Certificate", systemImage: "qrcode.viewfinder")
                }
            }
            
            Section(header: errorMsg) {
                ForEach(certificates) { cert in
                    NavigationLink {
                        QRCodeView(data: cert.vaccinationQRCodeData)
                    } label: {
                        Label("Certificate \(cert.vaccinationCertificate.hcert.dgc.v?.first?.dn ?? 0)/\(cert.vaccinationCertificate.hcert.dgc.v?.first?.sd ?? 0)", systemImage: "qrcode")
                    }
                }
            }
            
            Section {
                Button(action: done) {
                    Text("Done")
                }.disabled(!correctForm)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            let dummy = "HC1:NCFOXN%TS3DH3ZSUZK+.V0ETD%65NL-AH1YIIOOP-IEDCQN68WA+J7U:CAT4V22F/8X*G3M9JUPY0BX/KR96R/S09T./0LWTKD33238J3HKB5S4VV2 73-E3GG396B-43O058YIZ73423ZQT*EJMD3EV40ATOLN0$4*2D523U53/GNNM0323:QT4XATOB273I97EG3MHF3%8YC3YGFSZV9/0F.8HLVDEFV+0B/S7-SN2H N37J3JFT6LJS$98T5V7AMI5DN9QZ5Y0Q$UPE%5MZ5*T57ZA$O7T6LEJOA+MZ55EIIPEBFVA.QO5VA81K0ECM8CCR1SOOEA7IB6$C94JBPC9AFMO6HNVL6SH.6A4JBY.C4KE5.B--C$JDBLEH-BWOJ96K0DI1PC6LFDNJI-B7DA2KCUDBQEAJJKHHGEC8ZI9$JAQJKLFHDFROZ25%1NXPTG90Q480G:NE--ETAOR7G31BU187$BUPO8 FYL7AEFI+U/2VD3DXQB/OTC1IST0XIJRSE7+56NU%JS8FF%NKG30/A2PYK$ZE550GOV*0"
            NavigationView {
                CodeScannerView(codeTypes: [.qr], simulatedData: dummy, completion: handleScan)
                    .toolbar {
                        ToolbarItem{
                            Button("Close", action: { isShowingScanner = false })
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    @State private var errorString = ""
    
    var errorMsg: some View {
        if isShowingAlert {
            return AnyView(Text(errorString).font(.system(size: 17)).fontWeight(.semibold).foregroundColor(.orange))
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            do {
                isShowingAlert = false
                let certificate = try Scanner.extractPayload(payload: result.string)
                try addCertificate(certificate)
                timestamp = certificate.vaccinationCertificate.iat ?? Date.now
                let targetID = certificate.vaccinationCertificate.hcert.dgc.v?.first?.tg ?? "N/A"
                let vaccineID = certificate.vaccinationCertificate.hcert.dgc.v?.first?.mp ?? "N/A"
                
                let targetRequest = DiseaseTarget.fetchRequest()
                targetRequest.fetchLimit = 1
                targetRequest.predicate = NSPredicate(format: "id == %@", targetID)
                
                if let target = try viewContext.fetch(targetRequest).first {
                    diseaseSelection = target
                }
                
                let vaccineRequest = Vaccine.fetchRequest()
                vaccineRequest.fetchLimit = 1
                vaccineRequest.predicate = NSPredicate(format: "id == %@", vaccineID)
                if let vaccine = try viewContext.fetch(vaccineRequest).first {
                    vaccineSelection = vaccine
                }
            } catch ScannerError.certificateExists {
                errorString = "Certificate exists already"
                isShowingAlert = true
            } catch ScannerError.unsupportedPayload {
                errorString = "Only Vaccination Certificates are supported"
                isShowingAlert = true
            } catch {
                print("TODO: Error handling: \(error)")
            }
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    private func addCertificate(_ certificate: ExtendedCBORWebToken) throws {
        if certificates.contains(certificate) {
            throw ScannerError.certificateExists
        } else {
            certificates.append(certificate)
        }
    }
    
    private func done() {
        print("save Vaccination entry")
        if let target = diseaseSelection,
           let vaccine = vaccineSelection {
            
            let dto = AddVaccinationDTO(timestamp: timestamp, diseaseSelection: target, vaccineSelection: vaccine, valid: true, certificates: certificates)
            let persistence = PersistenceController.shared
            
            do {
                try persistence.addVaccination(dto, to: pass, context: viewContext)
                try viewContext.save()
                print("Vaccination saved succesfully")
                presentationMode.wrappedValue.dismiss()
            } catch {
                viewContext.rollback()
                print("Failed to save: \(error)")
                presentationMode.wrappedValue.dismiss()
                showAlertAfterError.toggle()
            }
        }
    }
}

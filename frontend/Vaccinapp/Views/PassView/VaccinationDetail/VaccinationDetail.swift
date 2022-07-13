//
//  VaccinationDetail.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 02.05.22.
//

import Foundation
import SwiftUI
import CodeScanner

struct VaccinationDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Vaccination
    @State var certificates: [ExtendedCBORWebToken]
    @State var isShowingScanner = false
    @State var refresh = false
    
    init (item: Vaccination) {
        self.item = item
        self.certificates = item.wrappedCertificates
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 7) {
                HStack {
                    Text("Disease:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(item.targetName)
                }
                HStack {
                    Text("Date:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(item.timestamp ?? Date.now, formatter: DateFormatter.medium)
                }
                Spacer()
                HStack {
                    Text("Vaccine:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(item.vaccine?.name ?? "MISSING")
                }
                HStack {
                    Text("Manufacturer:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(item.vaccine?.manufacturer ?? "MISSING")
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(20)
            .padding([.horizontal])
            
            CertificatePreview(certificates: $certificates)
                .padding([.top])
        }
        .navigationBarTitle(item.targetName)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem {
                Button(action: {isShowingScanner = true}) {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            let dummy = "HC1:NCFOXN%TS3DH3ZSUZK+.V0ETD%65NL-AH1YIIOOP-IEDCQN68WA+J7U:CAT4V22F/8X*G3M9JUPY0BX/KR96R/S09T./0LWTKD33238J3HKB5S4VV2 73-E3GG396B-43O058YIZ73423ZQT*EJMD3EV40ATOLN0$4*2D523U53/GNNM0323:QT4XATOB273I97EG3MHF3%8YC3YGFSZV9/0F.8HLVDEFV+0B/S7-SN2H N37J3JFT6LJS$98T5V7AMI5DN9QZ5Y0Q$UPE%5MZ5*T57ZA$O7T6LEJOA+MZ55EIIPEBFVA.QO5VA81K0ECM8CCR1SOOEA7IB6$C94JBPC9AFMO6HNVL6SH.6A4JBY.C4KE5.B--C$JDBLEH-BWOJ96K0DI1PC6LFDNJI-B7DA2KCUDBQEAJJKHHGEC8ZI9$JAQJKLFHDFROZ25%1NXPTG90Q480G:NE--ETAOR7G31BU187$BUPO8 FYL7AEFI+U/2VD3DXQB/OTC1IST0XIJRSE7+56NU%JS8FF%NKG30/A2PYK$ZE550GOV*0"
            CodeScannerView(codeTypes: [.qr], simulatedData: dummy, completion: handleScan)
        }
    }
    
    private func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            do {
                print(certificates.count)
                let certificate = try Scanner.extractPayload(payload: result.string)
                try item.addCertificate(certificate)
                try viewContext.save()
                certificates = item.wrappedCertificates
                print(certificates.count)
            } catch {
                print("TODO: Error handling: \(error)")
                viewContext.rollback()
            }
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
}

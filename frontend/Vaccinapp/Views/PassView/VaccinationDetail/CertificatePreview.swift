//
//  CertificatePreview.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.07.22.
//

import Foundation
import SwiftUI

struct CertificatePreview: View {
    @Binding var certificates: [ExtendedCBORWebToken]
    
    var body: some View {
        if let cert = certificates.first {
            NavigationLink (destination: QRCodeView(data: cert.vaccinationQRCodeData)){
                VStack {
                    QRCodePreview(data: cert.vaccinationQRCodeData)
                }
                .cornerRadius(7)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(20)
                .padding([.horizontal])
            }
            VStack(spacing: 7) {
                HStack {
                    Text("Immunity Status:")
                        .fontWeight(.semibold)
                    Spacer()
                    cert.vaccinationCertificate.hcert.dgc.v?.first?.fullImmunization ?? false ? checkmarkValid : checkmarkInvalid
                }
                HStack {
                    Text("Certificate:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(cert.vaccinationCertificate.hcert.dgc.v?.first?.dn ?? 0)/\(cert.vaccinationCertificate.hcert.dgc.v?.first?.sd ?? 0)")
                }
                HStack {
                    Text("Name:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(cert.vaccinationCertificate.hcert.dgc.nam.fullName)
                }
                HStack {
                    Text("Date of Birth:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(cert.vaccinationCertificate.hcert.dgc.dob ?? Date.now, formatter: DateFormatter.medium)
                }
                HStack {
                    Text("Expires at:")
                        .fontWeight(.semibold)
                    Spacer()
                    
                    if let date = cert.vaccinationCertificate.exp {
                        HStack {
                            if cert.vaccinationCertificate.isExpired {
                                Menu {
                                    Text("This certificate is expired and needs to be replaced!")
                                } label: {
                                    checkmarkInvalid
                                }
                            } else if cert.vaccinationCertificate.expiresSoon {
                                Menu {
                                    Text("The certificate expires soon.")
                                } label: {
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(.orange)
                                }
                            }
                            Text(date, formatter: DateFormatter.medium)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(20)
            .padding([.horizontal, .bottom])
            
            Text(cert.vaccinationCertificate.hcert.dgc.v?.first?.ciDisplayName ?? "")
                .foregroundColor(Color(.systemGray4))
                .font(.system(size: 12))
                .padding()
        } else {
            EmptyView()
        }
        
    }
    var checkmarkValid: Text {
        Text(Image(systemName: "checkmark.circle"))
            .foregroundColor(.green)
    }
    
    var checkmarkInvalid: Text {
        Text(Image(systemName: "xmark.circle"))
            .foregroundColor(.red)
    }
}

struct QRCodePreview: View {
    let data: String
    
    var body: some View {
        let view: AnyView
        
        if let image = data.generateQRCode() {
            view = AnyView(Image(uiImage: image).resizable().aspectRatio(1, contentMode: .fit))
        } else {
            view = AnyView(Text("No QR Code found!"))
        }
        
        return view
    }
}

struct QRCodeView: View {
    let data: String
    
    var body: some View {
        VStack(alignment: .center) {
            QRCodePreview(data: data)
                .padding()
        }
    }
}

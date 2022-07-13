//
//  Vaccination+Wrappers.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 06.05.22.
//

import Foundation
import SwiftCBOR

extension Vaccination {
    public var wrappedDate: Date {
        timestamp ?? Date.distantPast
    }
    
    public var wrappedCertificates: [ExtendedCBORWebToken] {
        guard let dataCertificates = certificates else {
            return [ExtendedCBORWebToken]()
        }
        
        do {
            let decoder = JSONDecoder()
            let wrapped = try decoder.decode([ExtendedCBORWebToken].self, from: dataCertificates)
            
            return wrapped.sorted()
        } catch {
            print("TODO: Handle broken Decoding")
            
        }
        return [ExtendedCBORWebToken]()
    }
    
    public var targetName: String {
        target?.name ?? "Missing Target"
    }
    
    public func addCertificate(_ cert: ExtendedCBORWebToken) throws {
        var existingCertificates = self.wrappedCertificates
        
        if existingCertificates.contains(cert) {
            throw GenericError.todo
        } else {
            for c in existingCertificates {
                if c.vaccinationCertificate.hcert.dgc.nam != cert.vaccinationCertificate.hcert.dgc.nam {
                    throw GenericError.todo
                }
            }
            if target?.id != cert.vaccinationCertificate.hcert.dgc.v?.first?.tg {
                throw GenericError.todo
            }
            existingCertificates.append(cert)
            
            let encoder = JSONEncoder()
            do {
                let encoded = try encoder.encode(existingCertificates)
                self.certificates = encoded
            } catch {
                print("JSON Encoding Error: \(error)")
            }
            
        }
    }
    
    public func validate() {
        let certs = wrappedCertificates
        if let cert = certs.first {
            if let valid = cert.vaccinationCertificate.hcert.dgc.v?.first?.fullImmunization {
                self.valid = valid
            } else {
                self.valid = false
            }
        }
    }
}

extension Vaccination: Comparable {
    public static func < (lhs: Vaccination, rhs: Vaccination) -> Bool {
        lhs.wrappedDate < rhs.wrappedDate
    }
}

extension Vaccination: Encodable {
    enum CodingKeys: CodingKey {
        case certificates,
             timestamp,
             manufacturer,
             vaccineName,
             targetID,
             valid
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(certificates, forKey: .certificates)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(vaccine?.name, forKey: .vaccineName)
        try container.encode(valid, forKey: .valid)
        try container.encode(target?.id, forKey: .targetID)
    }
}

extension Vaccination {
    func addPass(_ pass: VaccinationPass) {
        self.passName = pass.name
        self.pass = pass
    }
}

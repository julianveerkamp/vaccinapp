//
//  Porter.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 19.06.22.
//

import Foundation
import CryptoKit
import CoreData

enum ExportError: Error {
    case exportE
    case importE
}

struct Porter {
    func importPass(_ data: Data, key: SymmetricKey, context: NSManagedObjectContext) throws -> VaccinationPass {
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        let opened = try ChaChaPoly.open(sealedBox, using: key)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        
        return try decoder.decode(VaccinationPass.self, from: opened)
    }
    
    func exportPass(_ passToExport: VaccinationPass, key: SymmetricKey) throws -> URL{
        let encoder = JSONEncoder()
        let payload = try encoder.encode(passToExport)
        
        let encryptedContent = try ChaChaPoly.seal(payload, using: key).combined
        
        guard let url = encryptedContent.toFile(name: "\(passToExport.name).data") else {
            throw ExportError.exportE
        }
        return url
    }
}

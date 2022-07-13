//
//  ExtendedCBORWebToken.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//
//  modified by Julian Veerkamp
//      added .id to make Token Identifiable and Equatable

import Foundation

public enum CertType: String {
    case recovery = "r", test = "t", vaccination = "v"
}

public enum Property {
    case givenName, familyName, dateOfBirth
}

public struct ExtendedCBORWebToken: Codable, QRCodeScanable, Identifiable {
    public var id = UUID()
    
    /// CBOR web token vaccination certificate
    public var vaccinationCertificate: CBORWebToken

    /// Raw QRCode data of the cbor web token vaccination certificate
    public var vaccinationQRCodeData: String

    public var wasExpiryAlertShown: Bool?
    
    public var reissueProcessInitialAlreadySeen: Bool?
    
    public var reissueProcessNewBadgeAlreadySeen: Bool?

    public init(vaccinationCertificate: CBORWebToken, vaccinationQRCodeData: String) {
        self.vaccinationCertificate = vaccinationCertificate
        self.vaccinationQRCodeData = vaccinationQRCodeData
    }

    public func coseSign1Message() throws -> CoseSign1Message {
        let compressedAndEncodedMessage = vaccinationQRCodeData.stripPrefix()
        let compressedMessage = try Base45Coder.decode(compressedAndEncodedMessage)
        guard let message = Compression.decompress(Data(compressedMessage)) else {
            throw ApplicationError.general("Could not decompress QR Code data")
        }
        let coseSign1Message = try CoseSign1Message(
            decompressedPayload: message
        )
        return coseSign1Message
    }
}

extension ExtendedCBORWebToken: Equatable {
    public static func == (lhs: ExtendedCBORWebToken, rhs: ExtendedCBORWebToken) -> Bool {
        return lhs.vaccinationQRCodeData == rhs.vaccinationQRCodeData
    }
}

extension ExtendedCBORWebToken: Comparable {
    /// Sort by dose number of first vaccination, result date of first test or valid until date of first recovery
    public static func < (lhs: ExtendedCBORWebToken, rhs: ExtendedCBORWebToken) -> Bool {
        lhs.vaccinationCertificate.hcert.dgc.v?.first?.dn ?? 0 > rhs.vaccinationCertificate.hcert.dgc.v?.first?.dn ?? 0 ||
            lhs.vaccinationCertificate.hcert.dgc.t?.first?.sc ?? Date() > rhs.vaccinationCertificate.hcert.dgc.t?.first?.sc ?? Date() ||
            lhs.vaccinationCertificate.hcert.dgc.r?.first?.du ?? Date() > rhs.vaccinationCertificate.hcert.dgc.r?.first?.du ?? Date()
    }
}

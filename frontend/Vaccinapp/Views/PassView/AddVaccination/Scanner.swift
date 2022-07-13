//
//  Scanner.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 05.05.22.
//
//  decode(*) functions
//      © Copyright IBM Deutschland GmbH 2021
//      SPDX-License-Identifier: Apache-2.0
//    modifier by Julian Veerkamp on 07.05.22.

import Foundation
import SwiftCBOR


struct Scanner {
    static func extractPayload(payload: String) throws -> ExtendedCBORWebToken {
        if payload.hasPrefix("HC1:") {
            let base45Decoded = try Base45Coder.decode(String(payload.dropFirst(4)))
            guard let decompressedPayload = Compression.decompress(Data(base45Decoded)) else {
                throw ScannerError.unsupportedPayload
            }
            
            let cosePayload = try CoseSign1Message(decompressedPayload: decompressedPayload)
            
            let cborDecodedPayload = try CBOR.decode(cosePayload.payload)
            let certificateJson = decode(cborObject: cborDecodedPayload)!
            
            let serializedJSON = try JSONSerialization.data(withJSONObject: certificateJson as Any)
            let certificate = try JSONDecoder().decode(CBORWebToken.self, from: serializedJSON)
            
            return ExtendedCBORWebToken(vaccinationCertificate: certificate, vaccinationQRCodeData: payload)
           
        } else {
            throw ScannerError.unsupportedPayload
        }
    }
    
    private static func decode(cborObject: CBOR?) -> [String: Any]? {
        guard let cborData = cborObject, case let .map(cborMap) = cborData else { return nil }
        
        var result = [String: Any]()
        for (key, value) in cborMap {
            if let (k, v) = decode(key: key, value: value) {
                result.updateValue(v, forKey: k)
            }
        }
        
        return result
    }
    
    private static func decode(key: CBOR, value: CBOR) -> (String, Any)? {
        var k: String
        
        switch key {
        case let .utf8String(keyString):
            k = keyString
        case let .unsignedInt(keyInt):
            k = String(keyInt)
        case let .negativeInt(keyInt):
            k = "-\(keyInt + 1)"
        default:
            assertionFailure("CBOR key type not implemented, yet")
            return nil
        }
        
        guard let cborValue = decode(value: value) else {
            return nil
        }
        
        return (k, cborValue)
    }
    
    private static func decode(value: CBOR) -> Any? {
        switch value {
        case let .utf8String(valueString):
            return valueString
        case let .array(cborArray):
            let remappedResult = cborArray.map { self.decode(cborObject: $0) }
            return remappedResult
        case let .unsignedInt(valueInt):
            return valueInt
        case let .double(valueDouble):
            return valueDouble
        case let .map(valueMap):
            var result = [String: Any]()
            for (mapKey, mapValue) in valueMap {
                if let (k, v) = decode(key: mapKey, value: mapValue) {
                    result.updateValue(v, forKey: k)
                }
            }
            return result
        case let .tagged(_, cborValue):
            return decode(value: cborValue)
        default:
            return nil
        }
    }
}

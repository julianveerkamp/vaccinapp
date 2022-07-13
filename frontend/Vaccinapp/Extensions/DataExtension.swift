//
//  DataExtension.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.05.22.

import Foundation

extension Data {
    
    private func getdir() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        return paths[0] as NSString
    }
    
    func toFile(name: String) -> URL? {
        let path = getdir().appendingPathComponent(name)
        
        do {
            try self.write(to: URL(fileURLWithPath: path))
            
            return URL(fileURLWithPath: path)
        } catch {
            print(error)
        }
        
        return nil
    }
}

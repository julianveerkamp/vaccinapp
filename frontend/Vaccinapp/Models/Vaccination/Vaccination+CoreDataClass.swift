//
//  Vaccination+CoreDataClass.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 06.05.22.
//
//

import Foundation
import CoreData

@objc(Vaccination)
public class Vaccination: NSManagedObject, Decodable {
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { throw GenericError.todo }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Vaccination", in: context) else { throw GenericError.todo }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.certificates = try container.decodeIfPresent(Data.self, forKey: .certificates)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.valid = try container.decode(Bool.self, forKey: .valid)
        
        let vaccineName = try container.decodeIfPresent(String.self, forKey: .vaccineName)
        let vaccineRequest = Vaccine.fetchRequest()
        vaccineRequest.fetchLimit = 1
        
        if let vaccine = try? context.fetch(vaccineRequest).first {
            self.vaccine = vaccine
        } else {
            print("ERROR: Import failed to find fitting DiseaseTarget for id: \(vaccineName ?? "nil")")
        }
        
        
        let targetID = try container.decode(String.self, forKey: .targetID)
        let request = DiseaseTarget.get(for: targetID)
        request.fetchLimit = 1
        
        if let target = try? context.fetch(request).first {
            self.target = target
        } else {
            print("ERROR: Import failed to find fitting DiseaseTarget for id: \(targetID)")
        }
    }
}

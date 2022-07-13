//
//  RecommendationsNetworkController.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 03.07.22.
//

import Foundation
import Combine

class RecommendationsNetworkController: ObservableObject, RecommendationsService {
    var session: APIService
    var cancellables = [AnyCancellable]()
    let persistence: PersistenceController
    
    init(session: APIService = APISession()) {
        self.session = session
        self.persistence = PersistenceController.shared
    }
    
    func get(for country: Country) {
        let cancellable = self.get(country)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
            }) { (result) in
                let context = self.persistence.container.newBackgroundContext()
                
                for rec in result.recommendations {
                    self.persistence.addNewRecommendation(rec, context: context)
                }
                do {
                    try context.save()
                }
                catch {
                    context.rollback()
                    print("Unresolved error \(error)")
                }
            }
        cancellables.append(cancellable)
    }
}

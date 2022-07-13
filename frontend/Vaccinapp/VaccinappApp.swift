//
//  VaccinappApp.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 14.04.22.
//

import SwiftUI
import CoreData
import Combine

@main
struct VaccinappApp: App {
    @AppStorage("didLaunchBefore") var didLaunchBefore: Bool = false
    let persistenceController = PersistenceController.shared
    
    @StateObject var defaultPass: DefaultPass
    @State private var selection = 2
    
    init() {
        persistenceController.update()
        
        let context = persistenceController.container.viewContext
        let fetchRequest = DefaultPass.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        if let pass = try? context.fetch(fetchRequest).first {
            self._defaultPass = StateObject(wrappedValue: pass)
        } else {
            self._defaultPass = StateObject(wrappedValue: DefaultPass(context: context))
            try? context.save()
        }
        
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !didLaunchBefore {
                    Onboarding(defaultPass: defaultPass)
                } else {
                    TabView(selection: $selection) {
                        Recommendations(defaultPass: defaultPass)
                            .tabItem {
                                Image(systemName: "rectangle.stack")
                                Text("Recommendations")
                            }
                            .tag(1)
                        PassView(defaultPass: defaultPass)
                            .tabItem {
                                Image(systemName: "person.text.rectangle")
                                Text("Vaccinations")
                            }
                            .tag(2)
                        Settings()
                            .tabItem{
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                            .tag(3)
                    }
                }
            }
            .accentColor(.mint)
            .navigationViewStyle(StackNavigationViewStyle())
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

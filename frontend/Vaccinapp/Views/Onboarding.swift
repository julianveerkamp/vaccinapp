//
//  Onboarding.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 07.06.22.
//

import SwiftUI


struct Onboarding: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var name = ""
    @State var gender = Gender.none
    @State var dob = Date.now
    @State var type: PassType? = nil
    @State var showSheet = false
    
    @ObservedObject var defaultPass: DefaultPass
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Welcome")
                    .font(.system(size: 50))
                    .fontWeight(.black)
                    .foregroundStyle(LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottom
                    ))
                    .padding([.top], 50)
                Text(" \(name)")
                    .fontWeight(.black)
                    .font(.system(size: 40))
                    .foregroundStyle(LinearGradient(
                        colors: colorScheme == .light ? [Color(.black), Color(.systemGray2)] : [.gray, .white],
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                    .padding([.horizontal], 30)
                    .padding([.bottom], 7)
                

                Text("Create a new Pass to start managing your Vaccinations digitally.")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.systemGray))
            }
            .padding([.horizontal], 20)
            
            VStack(spacing: 20) {
                AddPass(name: $name, gender: $gender, dob: $dob, type: $type, defaultPass: defaultPass)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .padding()
            
            Text("You can add more passes through the settings menu later on.")
                .font(.system(size: 17))
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemGray2))
                .padding()
            
            Spacer ()
            
            Button {
                showSheet = true
            } label: {
                Text("Privacy Policy")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.systemGray))
                    .padding()
            }
        }.background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showSheet) {
                NavigationView {
                    PrivacyPolicy()
                        .toolbar {
                            ToolbarItem{
                                Button("Close", action: { showSheet = false })
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static let name = "Name abcd"
    
    static var previews: some View {
        let pass = DefaultPass(context: PersistenceController.preview.container.viewContext)
        Onboarding(name: name, defaultPass: pass)
            .accentColor(.mint)
            .preferredColorScheme(.light)
        Onboarding(name: name, defaultPass: pass)
            .accentColor(.mint)
            .preferredColorScheme(.dark)
    }
}

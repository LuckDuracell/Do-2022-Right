//
//  ContentView.swift
//  Do 2022 Right
//
//  Created by Luke Drushell on 1/1/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var user = User.loadFromFile()
    @State var name = ""
    @State var goals: [String] = [""]
    
    @State var showLauncher = false
    
    let year = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView {
            MainPage(user: $user)
            .navigationTitle("Do \(String(year)) Right")
            .sheet(isPresented: $showLauncher, content: {
                StartupSheet(user: $user, name: $name, goals: $goals, showSheet: $showLauncher)
                    .interactiveDismissDisabled()
            })
        } .onAppear(perform: {
            if user.isEmpty {
                showLauncher = true
                user = [User(name: "", goals: [], goalsTrue: [])]
                User.saveToFile(user)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

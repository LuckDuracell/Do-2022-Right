//
//  StartupSheet.swift
//  Do 2022 Right
//
//  Created by Luke Drushell on 1/1/22.
//

import SwiftUI

struct StartupSheet: View {
    
    @Binding var user: [User]
    @Binding var name: String
    @Binding var goals: [String]
    
    @Binding var showSheet: Bool
    
    let year = Calendar.current.component(.year, from: Date())
    
    var body: some View {
            ZStack {
                ScrollView {
                        VStack {
                            Rectangle()
                                .frame(width: 5, height: 50, alignment: .center)
                                .foregroundColor(.black.opacity(0))
                            VStack {
                                Text("Hey \(name == "" ? "friend" : name), lets grow this year!")
                                Text("Get started by jotting down some year goals")
                            } .padding(.top, 20)
                            
                            GroupBox(content: {
                                TextField("Name", text: $name)
                            }) .padding()
                            GroupBox(content: {
                                ForEach(goals.indices, id: \.self, content: { i in
                                    TextField("Goal \(i + 1)", text: $goals[i])
                                    Divider()
                                })
                                Button {
                                    withAnimation {
                                        goals.append("")
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                        .scaledToFit()
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.blue)
                                } .padding(.top, 5)
                            }) .padding(.horizontal)
                        }
                    
                    Rectangle()
                        .frame(width: 5, height: 550, alignment: .center)
                        .foregroundColor(.black.opacity(0))
                        
                }
                VStack {
                    Spacer()
                    ZStack {
                        LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                            .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .center)
                        Button {
                            if goals.isEmpty == false {
                                var completions: [Bool] = []
                                for _ in goals.indices {
                                    completions.append(false)
                                }
                                let newGoals = cleanGoals(goals: goals, completed: completions)
                                user.removeAll()
                                user.append(User(name: name, goals: newGoals.0, goalsTrue: newGoals.1))
                                User.saveToFile(user)
                                showSheet.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.blue)
                        }
                    }
                }
            } .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                name = user.first!.name
                goals = user.first!.goals
            })

    }
}

func cleanGoals(goals: [String], completed: [Bool]) -> ([String], [Bool]) {
    var verifiedGoals: [String] = []
    var verifiedToggles: [Bool] = []
    for i in goals.indices {
        if goals[i] != "" {
            verifiedGoals.append(goals[i])
            verifiedToggles.append(completed[i])
        }
    }
    return (verifiedGoals, verifiedToggles)
}

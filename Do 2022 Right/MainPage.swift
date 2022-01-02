//
//  MainPage.swift
//  Do 2022 Right
//
//  Created by Luke Drushell on 1/1/22.
//

import SwiftUI

struct MainPage: View {
    
    @Binding var user: [User]
    let emptyArray: [String] = []
    var body: some View {
        ZStack {
            ScrollView {
                
                GroupBox("\((100 - (yearPercent() * 100).rounded() / 100))% Left of 2022", content: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 25, alignment: .center)
                            .overlay(alignment: .leading, content: {
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .frame(width: UIScreen.main.bounds.width * 0.9 * yearPercent() / 100, height: 25, alignment: .leading)
                            })
                            .clipShape(Capsule())
                    }
                }) .padding()
                
                GroupBox("Your Goals", content: {
                    ForEach(user.first?.goals.indices ?? emptyArray.indices, id: \.self, content: { i in
                        TextField("Goal \(i + 1)", text: $user.first!.goals[i])
                            .onSubmit({
                                User.saveToFile(user)
                            })
                            .overlay(
                                Button {
                                    user[0].goalsTrue[i].toggle()
                                    User.saveToFile(user)
                                } label: {
                                    Image(systemName: user.first!.goalsTrue[i] ? "circle.inset.filled" : "circle")
                                        .resizable()
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .scaledToFit()
                                        .shadow(color: .black, radius: 10)
                                }
                                , alignment: .trailing)
                        Divider()
                    })
                    Button {
                        withAnimation {
                            user[0].goals.append("")
                        }
                        user[0].goalsTrue.append(false)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .scaledToFit()
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.blue)
                    } .padding(.top, 5)
                }) .padding()

                Spacer()
                
                Text("Hey \(user.isEmpty ? "" : "\(user.first!.name)"), today is as good as ever to get a move on becoming your best self in 2022. Get to working on one of those goals!")
                    .padding(50)
                    .multilineTextAlignment(.center)
                
            }
        } .onAppear(perform: {
            if user.isEmpty == false {
                user[0].goals = cleanGoals(goals: user[0].goals)
            }
        })
    }
}

func yearPercent() -> Double {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let startDate = formatter.date(from: "2022-01-01 00:00:00")!
    let endDate = formatter.date(from: "2022-12-31 23:59:59")!
    let currentDate = formatter.date(from: formatter.string(from: Date()))!
    
    let currentInterval = currentDate.timeIntervalSince(startDate)
    let endInterval = endDate.timeIntervalSince(startDate)
    let progress = currentInterval / endInterval * 100
    
    return progress
}

//
//  ContentView.swift
//  Random Saving
//
//  Created by 大迫亮斗 on 2024/06/22.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State var selection = 1
    init() {
        UITabBar.appearance().backgroundColor = .gray
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    var body: some View {
        TabView(selection: $selection) {
            Toppage()
                .tabItem {
                    Label("トップ", systemImage: "house.fill")
                }
                .tag(1)
            
            ListOfRecordsView()
                .tabItem {
                    Label("記録一覧", systemImage: "chart.bar.xaxis.ascending")
                }
                .tag(2)
            
            Setting()
                .tabItem {
                    Label("設定", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
    }
}
#Preview {
    ContentView()
}

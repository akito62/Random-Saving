//
//  ListOfRecordsView.swift
//  Random Saving
//
//  Created by 大迫亮斗 on 2024/06/24.
//

//import SwiftUI
//
//struct ListOfRecordsView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    ListOfRecordsView()
//}

import SwiftUI
import RealmSwift
import Charts

struct ListOfRecordsView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                let realm = try! Realm()
                let savingAc_obj = realm.objects(SavingAchievedTable.self)
                let count = savingAc_obj.count
                ForEach(0..<count) { num in
                    var achiv_day = savingAc_obj[num].achieved_at
                    var achiv_money = Double(savingAc_obj[num].money)
                    var data: [ToyShape] = [
                        .init(type: achiv_day, count: achiv_money)
                    ]
                    Chart {
                        BarMark(
                            x: .value("Shape Type", data[0].type),
                            y: .value("Total Count", data[0].count)
                        )
                    }
                }
//                var data: [ToyShape] = [
//                    .init(type: "Cube", count: 5),
//                    .init(type: "Sphere", count: 4),
//                    .init(type: "Pyramid", count: 4)
//                ]
//                Chart {
//                    BarMark(
//                        x: .value("Shape Type", data[0].type),
//                        y: .value("Total Count", data[0].count)
//                    )
//                    BarMark(
//                         x: .value("Shape Type", data[1].type),
//                         y: .value("Total Count", data[1].count)
//                    )
//                    BarMark(
//                         x: .value("Shape Type", data[2].type),
//                         y: .value("Total Count", data[2].count)
//                    )
//                }
            }
        }
    }
}

#Preview {
    ListOfRecordsView()
}

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

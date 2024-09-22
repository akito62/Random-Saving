//
//  Toppage.swift
//  Random Saving
//
//  Created by 大迫亮斗 on 2024/06/22.
//

import SwiftUI
import RealmSwift


struct Toppage: View {
    @State var monthMoney = 0
    @State var text = "達成"
    @State var disable = false
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("今日の貯金額")
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: 20))
                
                Text("\(getCurrentDate())")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 16)
                    .font(.system(size: 20))
                
                let randomNum = SavingPerDay()
                let achieved = SavingAchievedTable()
                let savingAc_month_obj = SavingAchievedMonth()
                let realm = try! Realm()
                let _ = print(realm.configuration.fileURL!)
                let perDay_obj = realm.objects(SavingPerDay.self).filter("created_at == '\(getCurrentDate())'")
                let _ = print(perDay_obj)
                let _ = print(getCurrentDate())
                let savingAc_obj = realm.objects(SavingAchievedTable.self).filter("achieved_at == '\(getCurrentDate())'")
                let _ = print(savingAc_obj)
                let _ = print(savingAc_obj.count)
                let savingAc_month = realm.objects(SavingAchievedMonth.self).filter("achieved_month == '\(getCurrentMonth())'")
                let _ = print(savingAc_month.count)
                if savingAc_month.count >= 1 {
                    let _ = self.monthMoney = savingAc_month[0].allMoney
                }
                let _ = print(getCurrentMonth())
                let achievedMon = getCurrentMonth()
                let threshold_obj = realm.objects(MimMaxNum.self)
                
                if perDay_obj.count == 0 {
                    if threshold_obj.count > 0 {
                        let _ = print("設定値あり")
                        var set_minNum = threshold_obj[0].mimNum
                        let _ = print(set_minNum)
                        var set_maxNum = threshold_obj[0].maxNum
                        let _ = print(set_maxNum)
                        let randomInt = (Int.random(in: set_minNum...set_maxNum) / 100) * 100
                        let create_at = getCurrentDate()
                        let _ = randomNum.created_at = create_at
                        let _ = randomNum.money = randomInt
                        let _ = randomNum.flag = false
                        let _ = try! realm.write {
                            realm.add(randomNum)
                        }
                        Text("\(randomInt)円")
                            .foregroundColor(Color.green)
                            .font(.system(size: 32))
                            .bold()
                    }else {
                        let _ = print("設定値なし")
                        let randomInt = (Int.random(in: 1000...2000) / 100) * 100
                        let create_at = getCurrentDate()
                        let _ = randomNum.created_at = create_at
                        let _ = randomNum.money = randomInt
                        let _ = randomNum.flag = false
                        let _ = try! realm.write {
                            realm.add(randomNum)
                        }
                        Text("\(randomInt)円")
                            .foregroundColor(Color.green)
                            .font(.system(size: 32))
                            .bold()
                    }
                    
                }else {
                    Text("\(perDay_obj[0].money)円")
                        .foregroundColor(Color.green)
                        .font(.system(size: 32))
                        .bold()
                }
                
                Rectangle()
                    .frame(width: 200, height: 5)
                    .foregroundColor(Color.cyan)
                    .padding(.bottom, 32)
                
                Button(action: {
                    if perDay_obj.count >= 1 && savingAc_obj.count ==  0 {
                        let achievedMoney  = perDay_obj[0].money
                        print("\(achievedMoney)")
                        let achievedDay = perDay_obj[0].created_at
                        print("\(achievedDay)")
                        let _ = achieved.money = achievedMoney
                        let _ = achieved.achieved_at = achievedDay
                        self.monthMoney = self.monthMoney + achievedMoney
                        try! realm.write {
                            realm.add(achieved)
                        }
                    }
                    
                    if perDay_obj.count >= 1 && savingAc_month.count == 0 {
                        let achievedMon = achievedMon
                        let achivedPerMoney = perDay_obj[0].money
                        let _ = savingAc_month_obj.achieved_month = achievedMon
                        let _ = savingAc_month_obj.allMoney = achivedPerMoney
                        try! realm.write {
                            realm.add(savingAc_month_obj)
                        }
                        try! realm.write {
                            perDay_obj[0].flag = true
                        }
                    } else {
                        if perDay_obj.count >= 1 && perDay_obj[0].flag == false {
                            try! realm.write {
                                perDay_obj[0].flag = true
                            }
                            let achivedPerMoney = perDay_obj[0].money
                            let originMoney = savingAc_month[0].allMoney
                            let sumMoney = achivedPerMoney + originMoney
                            self.monthMoney = sumMoney
                            self.text = "達成済"
                            try! realm.write {
                                savingAc_month[0].allMoney = sumMoney
                            }
                        }
                    }
                    
                }) {
                    VStack {
                        
                        Text("\(self.text)")
                            .onAppear{
                                if perDay_obj.count >= 1 && perDay_obj[0].flag == true {
                                    self.text = "達成済"
                                }
                            }
                            .font(.system(size: 24))
                            .padding()
                            .frame(width: 160, height: 60)
                            .foregroundColor(Color.white)
                            .background(Color.green)
                            .cornerRadius(10)
                            .bold()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    }
                }
                .disabled(self.disable)
                .onAppear{
                    if perDay_obj.count >= 1 {
                        self.disable = perDay_obj[0].flag
                    }
                }

                Text("今月の合計貯金額")
                    .foregroundColor(Color.white)
                    .font(.system(size: 32))
                    .bold()
                    .padding(.top,99)
                let recentMoney = realm.objects(SavingAchievedMonth.self).filter("achieved_month == '\(getCurrentMonth())'")
                Text("\(self.monthMoney)円")
                    .onAppear{
                        if savingAc_month.count >= 1 {
                            self.monthMoney = savingAc_month[0].allMoney
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding(.top,16)
                    .bold()
                    .font(.system(size: 32))
            }
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateStr = formatter.string(from: date as Date)
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale.current)
        return  dateStr
    }
    
    func getCurrentMonth() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        let dateStr = formatter.string(from: date as Date)
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale.current)
        return  dateStr
    }
    
    func getDate() -> Date {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale.current)
        return date
    }
}


#Preview {
    Toppage()
}

//
//  Setting.swift
//  Random Saving
//
//  Created by 大迫亮斗 on 2024/06/23.
//

import SwiftUI
import RealmSwift

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct Setting: View {
    // データがあればそこから引っ張る。なければ0
    @State var minMoney = 0
    @State var maxMoney = 0
    @State var dangerText = ""
    @State var emptyText = ""
    @FocusState var isActive:Bool
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("設定した最低金額〜最高金額の範囲で貯金額を提示します")
                    .foregroundColor(Color.white)
                    .font(.system(size:15))
                    .bold()
                    .padding(.bottom, 24)
                let realm = try! Realm()
                let thresMin_Max = MimMaxNum()
                let threshold_obj = realm.objects(MimMaxNum.self)

                Text("最低金額を入力してください")
                    .foregroundColor(Color.white)
                    .bold()
                Text("\(self.dangerText)")
                    .foregroundColor(Color.red)
                TextField("最低金額",value: $minMoney, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.bottom,24)
                    .onAppear() {
                        if threshold_obj.count > 0 {
                            self.minMoney = threshold_obj[0].mimNum
                        }
                    }
                
                Text("最高金額を入力してください")
                    .foregroundColor(Color.white)
                    .bold()
                TextField("最高金額", value: $maxMoney, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.bottom, 24)
                    .onAppear() {
                        if threshold_obj.count > 0 {
                            self.maxMoney = threshold_obj[0].maxNum
                        }
                    }
                
                    Button(action: {
                        UIApplication.shared.endEditing()
                    }, label: {
                        Text("入力を閉じる")
                            .bold()
                            .padding(.bottom,24)
                            .font(.system(size: 20))
                    })
                Button(action: {
                    if minMoney > maxMoney {
                        self.dangerText = "最高金額を越えないで下さい"
                    } else {
                        self.dangerText = ""
                        if threshold_obj.count == 0 {
                            thresMin_Max.mimNum = self.minMoney
                            thresMin_Max.maxNum = self.maxMoney
                            let _ = try! realm.write {
                                realm.add(thresMin_Max)
                            }
                        } else {
                            let _ = try! realm.write {
                                threshold_obj[0].mimNum = self.minMoney
                                threshold_obj[0].maxNum = self.maxMoney
                            }
                            let _ = print("更新")
                        }
                    }
                }) {
                    Text("設定を保存")
                        .font(.system(size: 24))
                        .padding()
                        .frame(width: 160, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(10)
                        .bold()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 3)
                        )
                    Text("\(self.emptyText)")
                        .foregroundColor(Color.red)
                }
            }
        }
    }
}

#Preview {
    Setting()
}

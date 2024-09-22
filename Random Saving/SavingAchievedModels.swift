//
//  SavingAchieved.swift
//  Random Saving
//
//  Created by 大迫亮斗 on 2024/06/23.
//

import Foundation
import RealmSwift

class SavingPerDay: Object{
    @Persisted var created_at: String = ""
    @Persisted var money = 0
    @Persisted var flag = false
}

class SavingAchievedTable: Object{
    // money
    @Persisted var money = 0
    // Achieved day
    @Persisted var achieved_at: String = ""
}

class SavingAchievedMonth: Object{
    //all money
    @Persisted var allMoney = 0
    // Achieved month
    @Persisted var achieved_month: String = ""
}

class MimMaxNum: Object{
    // mim number
    @Persisted var mimNum = 0
    @Persisted var maxNum = 0
}

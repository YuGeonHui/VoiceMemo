//
//  Todo.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/16/23.
//

import Foundation

struct Todo: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var convertedDayAndTime: String {
        // 오늘 - 오후 03:30에 알림
        String("\(day.formattedDay) - \(time.formattedTime)")
    }
}

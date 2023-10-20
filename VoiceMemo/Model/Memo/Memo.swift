//
//  Memo.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/17/23.
//

import Foundation

struct Memo: Hashable {
    
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var convertedDate: String {
        String("\(date.formattedDay) - \(date.formattedTime)")
    }
}

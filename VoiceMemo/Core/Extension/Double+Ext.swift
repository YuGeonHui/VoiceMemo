//
//  Double+Ext.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/18/23.
//

import Foundation

extension Double {
    
    // 03:05 (3분 5초)
    var formattedTimeInterval: String {
        
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minute = (totalSeconds / 60) % 60
        
        return String(format: "%02d:%02d", minute, seconds)
    }
}

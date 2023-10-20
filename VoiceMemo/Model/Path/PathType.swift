//
//  PathType.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/16/23.
//

import Foundation

enum PathType: Hashable {
    case homeView
    case todoView
    case memoview(isCreateMode: Bool, memo: Memo?)
}

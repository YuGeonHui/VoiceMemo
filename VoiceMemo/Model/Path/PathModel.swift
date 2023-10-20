//
//  PathModel.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/16/23.
//

import Foundation

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}

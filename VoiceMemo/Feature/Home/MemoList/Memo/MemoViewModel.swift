//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/17/23.
//

import Foundation

final class MemoViewModel: ObservableObject {
    
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}

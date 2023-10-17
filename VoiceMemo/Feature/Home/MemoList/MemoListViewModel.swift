//
//  MomoListViewModel.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/17/23.
//

import Foundation

final class MemoListViewModel: ObservableObject {
    
    @Published var memos: [Memo]
    @Published var isEditMemoMode: Bool
    @Published var removeMemos: [Memo]
    @Published var isDisplayRemoveAlert: Bool
    
    var removeMemoCount: Int {
        return removeMemos.count
    }
    
    var navigationBarRigthBtnMode: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(memos: [Memo] = [], isEditMemoMode: Bool = false, removeMemos: [Memo] = [], isDisplayRemoveAlert: Bool = false) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemos = removeMemos
        self.isDisplayRemoveAlert = isDisplayRemoveAlert
    }
}

extension MemoListViewModel {
    
}

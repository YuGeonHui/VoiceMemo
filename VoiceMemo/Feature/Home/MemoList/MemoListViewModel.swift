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
    
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        }
    }
    
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightBtnTapped() {
        
        if isEditMemoMode {
            if removeMemos.isEmpty {
                isEditMemoMode = false
            } else {
                // 삭제 얼럿 상태 값 변경을 위한 메서드 호출
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            isEditMemoMode = true
        }
    }
    
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
        isDisplayRemoveAlert = isDisplay
    }
    
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        if let index = removeMemos.firstIndex(of: memo) {
            removeMemos.remove(at: index)
        } else {
            removeMemos.append(memo)
        }
    }
    
    func removeBtnTapped() {
        memos.removeAll { memo in
            removeMemos.contains(memo)
        }
        removeMemos.removeAll()
        isEditMemoMode = false
    }
}

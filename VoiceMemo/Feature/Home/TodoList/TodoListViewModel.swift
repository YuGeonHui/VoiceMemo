//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/16/23.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    
    @Published var todos: [Todo] = []
    @Published var isEditTodMode: Bool = false
    @Published var removeTodos: [Todo] = []
    @Published var isDisplayRemoveTodoAlert: Bool = false
    
    var removeTodosCount: Int {
        return removeTodos.count
    }
    
    var navigationBarRightBtnMode: NavigationBtnType {
        return isEditTodMode ? .complete : .edit
    }
}

extension TodoListViewModel {
    
    func selectedBoxTapped(_ todo: Todo) {
        
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func navigationRightButtonTapped() {
        if isEditTodMode {
            if removeTodos.isEmpty {
                isEditTodMode = false
            } else {
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditTodMode = true
        }
    }
    
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    func removeBtnTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        
        removeTodos.removeAll()
        isEditTodMode = false
    }
}

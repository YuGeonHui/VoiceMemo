//
//  TodoView.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/16/23.
//

import SwiftUI

struct TodoView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        
        VStack {
            
            CustomNavigationBar(
                leftBtnAction: { pathModel.paths.removeLast() },
                rightBtnAction: {
                    todoListViewModel.addTodo(
                        .init(title: todoViewModel.title,
                              time: todoViewModel.time,
                              day: todoViewModel.day,
                              selected: false))
                    
                    pathModel.paths.removeLast()
                },
                rightBtnType: .create)
            
            TitleView()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            SelectTimeVieW(todoViewModel: todoViewModel)
            
            SelectDayView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("To do list를\n추가해 보세요.")
            
            Spacer()
        }
        
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: Todo 타이틀 뷰 (텍스트 필드)
private struct TodoTitleView: View {
    
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요", text: $todoViewModel.title)
    }
}

// MARK: - 시간 선택 뷰
private struct SelectTimeVieW: View {
    
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        
        VStack {
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
            
            DatePicker("", selection: $todoViewModel.time, displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 날짜 선택 뷰
private struct SelectDayView: View {
    
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        
        VStack(spacing: 5) {
            
            HStack {
                
                Text("날짜")
                    .foregroundColor(.customIconGray)
                
                Spacer()
            }
            
            HStack {
                
                Button(action: { todoViewModel.setIsDisplayCalendar(true)} ) {
                    Text("\(todoViewModel.day.formattedDay)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.customGreen)
                }
                .popover(isPresented: $todoViewModel.isDisplayCalendar) {
                    
                    DatePicker("", selection: $todoViewModel.day, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .onChange(of: todoViewModel.day) { _ in
                            // day가 변경될때마다
                            todoViewModel.setIsDisplayCalendar(false)
                        }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    TodoView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
}

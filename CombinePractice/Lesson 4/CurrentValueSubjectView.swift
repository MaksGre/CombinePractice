//
//  CurrentValueSubjectView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 13.01.2025.
//

import SwiftUI
import Combine

/// @Published                                      CurrentValueSubject
/// 1.Запускается pipeline                  1. Устанавливается значение
/// 2. Устанавливается значение      2.Запускается pipeline
/// 3.UI автоматом                              3.Ul update через objectWillChange.send()
 
struct CurrentValueSubjectView: View {
    @StateObject private var viewModel = CurrentValueSubjectViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.selectionSame.value ? "Два раза выбрали значение" : "") \(viewModel.selection.value)")
                .foregroundColor(viewModel.selectionSame.value ? .red : .green)
                .padding()
            
            Button("Выбрать колу") {
                viewModel.selection.value = "Кола" // можно так присвоить
            }
            .padding()

            Button("Выбрать бургер") {
                viewModel.selection.send("Бургер") // а можно через send
            }
            .padding()
        }
    }
}

class CurrentValueSubjectViewModel: ObservableObject {
    var selection = CurrentValueSubject<String, Never>("Корзина пуста")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                newValue == selection.value
            }
            .sink { [unowned self] value in
                selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
}

struct CurrentValueSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentValueSubjectView()
    }
}

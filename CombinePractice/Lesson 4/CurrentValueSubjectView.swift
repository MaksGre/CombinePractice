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
            Text("\(viewModel.selectionSame ? "Два раза выбрали значение" : "") \(viewModel.selection)")
                .foregroundColor(viewModel.selectionSame ? .red : .green)
                .padding()
            
            Button("Выбрать колу") {
                viewModel.selection = "Кола"
            }
            .padding()

            Button("Выбрать бургер") {
                viewModel.selection = "Бургер"
            }
            .padding()
        }
    }
}

class CurrentValueSubjectViewModel: ObservableObject {
    @Published var selection = "Корзина пуста"
    @Published var selectionSame = false
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        $selection
            .map { [unowned self] newValue -> Bool in
                newValue == selection
            }
            .sink { [unowned self] value in
                selectionSame = value
            }
            .store(in: &cancellable)
    }
}

struct CurrentValueSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentValueSubjectView()
    }
}

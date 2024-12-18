//
//  FirstCancellablePipelineView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 18.12.2024.
//

import SwiftUI
import Combine

struct FirstCancellablePipelineView: View {
    @StateObject var viewModel = FirstCancellablePipelineViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundStyle(.green)
            
            Text(viewModel.status)
                .foregroundStyle(.blue)
            
            Spacer()
            
            Button {
                viewModel.cancel()
            } label: {
                Text("Отменить подписку")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.red)
            .cornerRadius(8)
            .opacity(viewModel.status == "Запрос в банк..." ? 1.0 : 0.0)
            
            Button {
                viewModel.refresh()
            } label: {
                Text("Запрос данных")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
    }
}

class FirstCancellablePipelineViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
                status = "Запрос в банк..."
                return value
                
            }
            .delay(for: 5, scheduler: DispatchQueue.main)
            .sink { [unowned self] value in
                self.data = "Сумма всех счетов 1 млн."
                self.status = "Данные получены"
            }
    }
    
    func refresh() {
        data = "Перезапрос данных"
    }
    
    func cancel() {
        status = "Операция отменена"
        cancellable?.cancel()
        cancellable = nil
    }
}

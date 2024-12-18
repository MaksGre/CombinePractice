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
        HStack {
            TextField("Ваше имя", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text(viewModel.validation)
        }
        .padding()
        
        Button("Отмена подписки") {
            viewModel.validation = ""
            viewModel.anyCancellable?.cancel()
        }
        
    }
}

class FirstCancellablePipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var validation = ""
    
    var anyCancellable: AnyCancellable?
    
    init() {
        anyCancellable = $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { value in
                self.validation = value
            }
    }
}

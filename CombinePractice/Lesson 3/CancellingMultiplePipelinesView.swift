//
//  Untitled.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 09.01.2025.
//

import SwiftUI
import Combine

struct CancellingMultiplePipelinesView: View {
    
    @StateObject private var viewModel = CancellingMultiplePipelinesViewModel()
    
    var body: some View {
        Group {
            HStack {
                TextField("Имя", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.firstNameValidation)
            }
            HStack {
                TextField("Фамилия", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.lastNameValidation)
            }
        }
        .padding()
        
        Button("Отменить все проверки") {
            viewModel.cancelAllValidation()
        }
    }
}

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var firstNameValidation: String = ""
    
    @Published var lastName: String = ""
    @Published var lastNameValidation: String = ""
    
    private var validationCancellables: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map { $0.isEmpty ? "❌" : "✅"}
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $lastName
            .map { $0.isEmpty ? "❌" : "✅"}
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func cancelAllValidation() {
        firstNameValidation = ""
        lastNameValidation = ""
        validationCancellables.removeAll()
    }
}

struct CancellingMultiplePipelinesView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CancellingMultiplePipelinesView()
    }
}

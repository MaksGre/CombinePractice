//
//  FailPublisherView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 13.01.2025.
//

import SwiftUI
import Combine

struct FailPublisherView: View {
    @StateObject var viewModel = FailPublisherViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.age)")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            
            TextField("Введите возраст", text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding()
            
            Button("Save") {
                viewModel.save()
            }
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Ошибка"), message: Text(error.rawValue))
        }
    }
}

enum InvalidAgeError: String, Error, Identifiable {
    var id: String { rawValue }
    case lessZero = "Значение не может быть меньше нуля"
    case moreHundred = "Значение не может быть больше 100"
}

class FailPublisherViewModel: ObservableObject {
    @Published var text = ""
    @Published var age = 0
    @Published var error: InvalidAgeError?
    
    func save() {
        _ = validationPublisher(age: Int(text) ?? -1)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] value in
                self.age = value
            }
        
    }
    
    func validationPublisher(age: Int) -> AnyPublisher<Int, InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.lessZero)
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreHundred)
                .eraseToAnyPublisher()
        }
        
        return Just(age)
            .setFailureType(to: InvalidAgeError.self)
            .eraseToAnyPublisher()
    }
}

struct FailPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        FailPublisherView()
    }
}

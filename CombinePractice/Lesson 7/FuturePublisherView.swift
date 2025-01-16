//
//  FuturePublisherView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 14.01.2025.
//

import SwiftUI
import Combine

struct FuturePublisherView: View {
    @StateObject var viewModel = FuturePublisherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.firstResult)
            
            Button("Запуск") {
                viewModel.runAgain()
            }
            
            Text(viewModel.secondResult)
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

class FuturePublisherViewModel: ObservableObject {
    @Published var firstResult = ""
    @Published var secondResult = ""
    
    let futurePublisher = Deferred {
        Future<String, Never> { promise in
            promise(.success("Future Publisher сработал"))
            print("Future Publisher сработал")
        }
    }
    
    func createFetch(url: URL, completion: @escaping (Result<String, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            completion(.success(response?.url?.absoluteString ?? ""))
        }
        
        task.resume()
    }
    
    func fetch() {
        guard let url = URL(string: "") else { return }
        createFetch(url: url) { result in
            switch result {
            case .success(let obj):
                print(obj)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func runAgain() {
        futurePublisher
            .assign(to: &$secondResult)
    }
}

struct FuturePublisherView_Previews: PreviewProvider {
    static var previews: some View {
        FuturePublisherView()
    }
}

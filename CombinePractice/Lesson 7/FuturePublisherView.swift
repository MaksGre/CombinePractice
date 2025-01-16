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
                viewModel.fetch ()
            }
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

class FuturePublisherViewModel: ObservableObject {
    @Published var firstResult = ""
    
    var cancellable: AnyCancellable?
     
    func createFetch(url: URL) -> AnyPublisher<String?, Error> {
        Future { promise in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    promise(.failure(error))
                    return
                }
                
                promise(.success(response?.url?.absoluteString ?? ""))
            }
            
            task.resume()
        }
        .eraseToAnyPublisher()
    }
    
    func fetch() {
        guard let url = URL(string: "https://google.com") else { return }
        
        cancellable = createFetch(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] value in
                firstResult = value ?? ""
            }
    }
}

struct FuturePublisherView_Previews: PreviewProvider {
    static var previews: some View {
        FuturePublisherView()
    }
}

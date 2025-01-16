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
    
    func fetch() {
        futurePublisher
            .assign(to: &$firstResult)
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

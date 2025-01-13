//
//  EmptyFailurePublishersView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 13.01.2025.
//

import SwiftUI
import Combine

struct EmptyPublishersView: View {
    @StateObject private var viewModel = EmptyFailurePublishersViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            .font(.title)
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

class EmptyFailurePublishersViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    
    let datas = [
        "Value 1",
        "Value 2",
        "Value 3",
        nil,
        "Value 5",
        "Value 6",
    ]
    
    func fetch() {
        _ = datas.publisher
            .flatMap { item -> AnyPublisher<String, Never> in
                if let item {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            }
            .sink { [unowned self] item in
                dataToView.append(item)
            }
    }
}

struct EmptyFailurePublishersView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPublishersView()
    }
}

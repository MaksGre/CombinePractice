//
//  URLSessionDataTaskPublisherView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 17.01.2025.
//

import SwiftUI
import Combine

/// "https://jsonplaceholder.typicode.com/posts"
/// "https://via.placeholder.com/600/d32776"

struct URLSessionDataTaskPublisherView: View {
    @StateObject var viewModel = URLSessionDataTaskPublisherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List(viewModel.dataToView, id: \.title) { post in
                Text(post.title)
                    .font(.title)
                    .bold()
                Text(post.body)
                    .font(.caption2)
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct Post: Decodable {
    let title: String
    let body: String
}

class URLSessionDataTaskPublisherViewModel: ObservableObject {
    @Published var dataToView: [Post] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] posts in
                dataToView = posts
            }
            .store(in: &cancellables)
    }
}

struct URLSessionDataTaskPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        URLSessionDataTaskPublisherView()
    }
}

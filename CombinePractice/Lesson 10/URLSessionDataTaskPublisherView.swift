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
            viewModel.avatarImage
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

struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    let body = "try again later"
}

class URLSessionDataTaskPublisherViewModel: ObservableObject {
    @Published var avatarImage: Image?
    @Published var alertError: ErrorForAlert?
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetch() {
        guard let url = URL(string: "https://via.placeholder.com/600/d32776") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                guard let uiImage = UIImage(data: data) else {
                    throw ErrorForAlert(message: "No image")
                }
                return Image(uiImage: uiImage)
            }
            .receive(on: RunLoop.main)
            .replaceError(with: Image("blank"))
            .sink { [unowned self] image in
                avatarImage = image
            }
            .store(in: &cancellables)
    }
}

struct URLSessionDataTaskPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        URLSessionDataTaskPublisherView()
    }
}

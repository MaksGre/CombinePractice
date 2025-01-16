//
//  JustSequenceView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 16.01.2025.
//

import SwiftUI
import Combine

struct JustSequenceView: View {
    @StateObject var viewModel = JustSequenceViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.title)
                .bold()
            
            Form {
                Section(header: Text("Участники конкурса").padding()) {
                    List(viewModel.dataToView, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

class JustSequenceViewModel: ObservableObject {
    @Published var title = ""
    @Published var dataToView: [String] = []
    
    var names = ["Julian", "Jack", "Marianna"]
    
    func fetch() {
        _ = names.publisher
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [unowned self] value in
                dataToView.append(value)
                print(value)
            })
        
        if names.count > 0 {
            Just(names[1])
                .map { item in
                    item.uppercased()
                }
                .assign(to: &$title)
        }
    }
}

struct JustSequenceView_Previews: PreviewProvider {
    static var previews: some View {
        JustSequenceView()
    }
}

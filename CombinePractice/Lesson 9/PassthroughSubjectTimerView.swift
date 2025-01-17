//
//  PassthroughSubjectTimerView.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 17.01.2025.
//

import SwiftUI
import Combine

enum ViewState<Model> {
    case loading
    case data(_ data: Model)
    case error(_ error: Error)
}

struct PassthroughSubjectTimerView: View {
    @StateObject var viewModel = PassthroughSubjectTimerViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Button("Старт") {
                    viewModel.verifyState.send("00:00")
                    viewModel.start()
                }
            case .data(let time):
                Text(time)
                    .font(.title)
                    .foregroundColor(.green)
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
    }
}

class PassthroughSubjectTimerViewModel: ObservableObject {
    @Published var state: ViewState<String> = .loading
    
    let verifyState = PassthroughSubject<String, Never>()
    
    var cancellable: AnyCancellable?
    var timerCancellable: AnyCancellable?
    
    init() {
        bind()
    }
    
    func bind() {
        cancellable = verifyState
            .sink(receiveValue: { [unowned self] value in
                if !value.isEmpty {
                    state = .data(value)
                } else {
                    state = .error(NSError(domain: "Error time", code: 101))
                }
            })
    }
    
    func start() {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "00:ss"
        
        timerCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] datum in
                verifyState.send(timeFormat.string(from: datum))
            })
    }
}

struct PassthroughSubjectTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PassthroughSubjectTimerView()
    }
}

//
//  FirstPipeline.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 04.12.2024.
//

import SwiftUI

struct FirstPipelineView: View {
    
    @StateObject var viewModel = FirstPipelineViewModel()
    @State var validation = ""
    
    var body: some View {
        HStack {
            TextField("Ваше имя", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.name) {
                    validation = $0.isEmpty ? "❌" : "✅"
                }
            Text(validation)
        }
        .padding()
    }
}

class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    
    init() {
          
    }
}

struct FirstPipelineView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPipelineView()
    }
}

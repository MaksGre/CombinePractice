//
//  CombinePracticeApp.swift
//  CombinePractice
//
//  Created by Maksim Grebenozhko on 04.12.2024.
//

import SwiftUI

@main
struct CombinePracticeApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView() // default
//            FirstPipelineView() // Lesson 1
//            FirstCancellablePipelineView() // Lesson 2
            CancellingMultiplePipelinesView() // Lesson 3
        }
    }
}

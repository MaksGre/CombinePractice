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
//            CancellingMultiplePipelinesView() // Lesson 3
//            CurrentValueSubjectView() // Lesson 4
//            EmptyPublishersView() // Lesson 5
//            FailPublisherView() // Lesson 6
//            FuturePublisherView() // Lesson 7
//            JustSequenceView() // Lesson 8
            PassthroughSubjectTimerView() // Lesson 9
        }
    }
}

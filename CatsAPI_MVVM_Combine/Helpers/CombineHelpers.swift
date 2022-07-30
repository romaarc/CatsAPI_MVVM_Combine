//
//  RxHelpers.swift
//  CatsAPI_MVVM_RxSwift
//
//  Created by Roman Gorshkov on 28.12.2021.
//

import UIKit
import Combine

final class ControlPublisher<T: UIControl>: Publisher {
    typealias ControlEvent = (control: UIControl, event: UIControl.Event)
    typealias Output = ControlEvent
    typealias Failure = Never
    
    let subject = PassthroughSubject<Output, Failure>()
    
    convenience init(control: UIControl, event: UIControl.Event) {
        self.init(control: control, events: [event])
    }
    
    init(control: UIControl, events: [UIControl.Event]) {
        for event in events {
            control.addTarget(self, action: #selector(controlAction), for: event)
        }
    }
    
    @objc private func controlAction(sender: UIControl, forEvent event: UIControl.Event) {
        subject.send(ControlEvent(control: sender, event: event))
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, ControlPublisher.Failure == S.Failure, ControlPublisher.Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

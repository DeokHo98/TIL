//
//  Observer.swift
//  Project-ClonePassOrder
//
//  Created by 정덕호 on 2022/05/30.
//

import Foundation

class Observer<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    func bind(completion: @escaping (T) -> Void) {
        self.listener = completion
    }
    init(value: T) {
        self.value = value
    }
}

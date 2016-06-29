//
//  Queue.swift
//  SimpleLabirynth
//
//  Created by Hubert on 28.06.2016.
//  Copyright © 2016 Hubert. All rights reserved.
//

import Foundation

struct Queue<Element> {
    private var items = [Element]()

    mutating func push(item: Element) {
        items.insert(item, atIndex: 0)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }

    func isEmpty() -> Bool {
        return items.isEmpty
    }
}
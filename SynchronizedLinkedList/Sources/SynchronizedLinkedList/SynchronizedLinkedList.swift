//
//  SynchronizedLinkedList.swift
//  SynchronizedLinkedList
//
//  Created by Mohamed Afsar on 24/03/20.
//  Copyright © 2020 Mohamed Afsar. All rights reserved.
//

import Foundation
import DoublyLinkedList

open class SynchronizedLinkedList<T: Equatable>: DoublyLinkedList<T> {
    // MARK: Open IVars
    open override var first: T? {
        var result: T?
        self.cQueue.sync { [weak self] in result = self?.superFirst() }
        return result
    }
    open override var last: T? {
        var result: T?
        self.cQueue.sync { [weak self] in result = self?.superLast() }
        return result
    }
    open override var count: Int {
        var result = 0
        self.cQueue.sync { [weak self] in
            result = self?.superCount() ?? 0
        }
        return result
    }
    open override var isEmpty: Bool {
        var result = false
        self.cQueue.sync { [weak self] in
            result = self?.superIsEmpty() ?? false
        }
        return result
    }

    // CustomStringConvertible
    open override var description: String {
        var result = ""
        self.cQueue.sync { [weak self] in
            result = self?.superDescription() ?? ""
        }
        return result
    }
    
    // MARK: Private ICons
    private let cQueue: DispatchQueue = {
        let queueId = String(describing: SynchronizedLinkedList.self) + "." + "concurrent" + "." + "\(Date().timeIntervalSince1970)" // NO I18N
        return DispatchQueue(label: queueId, qos: .userInitiated, attributes: .concurrent)
    }()
    
    // MARK: Initialization
    required public init() {
        super.init()
    }
    
    required public convenience init(arrayLiteral elements: T...) {
        self.init()
        self.append(elements)
    }
    
    public convenience init(_ element: T) {
        self.init()
        self.append(element)
    }
    
    public convenience init(_ elements: [T]) {
        self.init()
        self.append(elements)
    }
    
    // MARK: Open Manipulating Functions
    open override func append(_ elements: [T]) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superAppend(elements) }
    }
    
    open override func append(_ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superAppend(element) }
    }
    
    open override func prepend(_ elements: [T]) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superPrepend(elements) }
    }
    
    open override func prepend(_ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superPrepend(element) }
    }
    
    open override func insert(_ element: T, at idx: Int) {
        self.cQueue.async(flags: .barrier) { [weak self] in
            self?.superInsert(element, at: idx)
        }
    }
        
    open override func removeAll() {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemoveAll() }
    }
    
    open override func removeFirst() {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemoveFirst() }
    }
    
    open override func removeLast() {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemoveLast() }
    }
    
    open override func remove(_ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemove(element) }
    }
    
    open override func remove(at idx: Int) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemove(at: idx) }
    }
    
    // MARK: Open Reading Functions
    open override func index(_ element: T) -> Int? {
        var result: Int?
        self.cQueue.sync { [weak self] in
            result = self?.superIndex(element)
        }
        return result
    }
    
    open override subscript(idx: Int) -> T? {
        get {
            var result: T?
            self.cQueue.sync { [weak self] in result = self?.superSubscript(idx: idx) }
            return result
        }
        set {
            guard let newValue = newValue else { return }
            self.cQueue.async(flags: .barrier) { [weak self] in
                self?.superSubscriptSet(idx: idx, newValue)
            }
        }
    }
    
    open override func find(at idx: Int) -> T? {
        var result: T?
        self.cQueue.sync { [weak self] in
            result = self?.superFind(at: idx)
        }
        return result
    }
    
    open override func forEach(reversed: Bool = false, _ body: ((T) -> Void)) {
        self.cQueue.sync { [weak self] in
            self?.superForEach(reversed: reversed, body)
        }
    }
    
    open override func enumerateObjects(reversed: Bool = false, _ body: ((_ obj: T, _ idx: Int, _ stop: inout Bool) -> Void)) {
        
        self.cQueue.sync { [weak self] in self?.superEnumerateObjects(reversed: reversed, body)
        }
    }

    open override func printAllKeys(reversed: Bool = false) {
        self.cQueue.async { [weak self] in self?.superPrintAllKeys(reversed: reversed)
        }
    }
}

// MARK: Private Proxy Functions
private extension SynchronizedLinkedList {
    // Wrote these proxy function is because of compiler error below.
    
    // Using 'super' in a closure where 'self' is explicitly captured is not yet supported - (31/03/2020)
    
    func superFirst() -> T? { super.first }
    
    func superLast() -> T? { super.last }
    
    func superCount() -> Int { super.count }
    
    func superIsEmpty() -> Bool { super.isEmpty }
    
    func superDescription() -> String { return super.description }
    
    func superAppend(_ elements: [T]) { super.append(elements) }
    
    func superAppend(_ element: T) { super.append(element) }
    
    func superPrepend(_ elements: [T]) { super.prepend(elements) }
    
    func superPrepend(_ element: T) { super.prepend(element) }
    
    func superInsert(_ element: T, at idx: Int) { super.insert(element, at: idx) }
    
    func superRemoveAll() { super.removeAll() }
    
    func superRemoveFirst() { super.removeFirst() }
    
    func superRemoveLast() { super.removeLast() }
    
    func superRemove(_ element: T) { super.remove(element) }
    
    func superRemove(at idx: Int) { super.remove(at: idx) }
    
    func superIndex(_ element: T) -> Int? { super.index(element) }
    
    func superSubscript(idx: Int) -> T? { super[idx] }
    
    func superSubscriptSet(idx: Int, _ element: T) { super[idx] = element }
    
    func superFind(at idx: Int) -> T? { super.find(at: idx) }
    
    func superForEach(reversed: Bool, _ body: ((T) -> Void)) {
        super.forEach(reversed: reversed, body)
    }
    
    func superEnumerateObjects(reversed: Bool, _ body: ((_ obj: T, _ idx: Int, _ stop: inout Bool) -> Void)) {
        super.enumerateObjects(reversed: reversed, body)
    }
    
    func superPrintAllKeys(reversed: Bool) {
        super.printAllKeys(reversed: reversed)
    }
}

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
    open override var first: T? { self._first }
    open override var last: T? { self._last }
    open override var count: Int { self._count }
    open override var isEmpty: Bool { self._isEmpty }

    // CustomStringConvertible
    open override var description: String { self._description }
    
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
        self._append(elements)
    }
    
    public convenience init(_ element: T) {
        self.init()
        self._append(element)
    }
    
    public convenience init(_ elements: [T]) {
        self.init()
        self._append(elements)
    }
    
    // MARK: Open Manipulating Functions
    open override func append(_ elements: [T]) {
        self._append(elements)
    }
    
    open override func append(_ element: T) {
        self._append(element)
    }
    
    open override func prepend(_ elements: [T]) {
        self._prepend(elements)
    }
    
    open override func prepend(_ element: T) {
        self._prepend(element)
    }
    
    open override func replace(at idx: Int, _ element: T) {
        self._replace(at: idx, element)
    }
    
    open override func insert(_ element: T, at idx: Int) {
        self._insert(element, at: idx)
    }
        
    open override func removeAll() {
        self._removeAll()
    }
    
    open override func removeFirst() {
        self._removeFirst()
    }
    
    open override func removeLast() {
        self._removeLast()
    }
    
    open override func remove(_ element: T) {
        self._remove(element)
    }
    
    open override func remove(at idx: Int) {
        self._remove(at: idx)
    }
    
    // MARK: Open Reading Functions
    open override func index(_ element: T) -> Int? {
        self._index(element)
    }
    
    open override subscript(idx: Int) -> T? {
        get {
            self._getSubscript(idx: idx)
        }
        set {
            guard let newValue = newValue else { return }
            self._setSubscript(idx: idx, newValue)
        }
    }
    
    open override func find(at idx: Int) -> T? {
        self._find(at: idx)
    }
    
    open override func forEach(reversed: Bool = false, _ body: ((T) -> Void)) {
        self._forEach(reversed: reversed, body)
    }
    
    open override func enumerateObjects(reversed: Bool = false, _ body: ((_ obj: T, _ idx: Int, _ stop: inout Bool) -> Void)) {
        self._enumerateObjects(reversed: reversed, body)
    }

    open override func printAllKeys(reversed: Bool = false) {
        self._printAllKeys(reversed: reversed)
    }
}

// MARK: Private Helper Functions
private extension SynchronizedLinkedList {
    // This `[weak self]` thingy in the blocks is to prevent crashes caused by asynchronous execution of the Queue even after the object gets deallocated.
    
    // MARK: Private IVars
    var _first: T? {
        var result: T?
        self.cQueue.sync { [weak self] in result = self?.superFirst() }
        return result
    }
    var _last: T? {
        var result: T?
        self.cQueue.sync { [weak self] in result = self?.superLast() }
        return result
    }
    var _count: Int {
        var result = 0
        self.cQueue.sync { [weak self] in
            result = self?.superCount() ?? 0
        }
        return result
    }
    var _isEmpty: Bool {
        var result = false
        self.cQueue.sync { [weak self] in
            result = self?.superIsEmpty() ?? false
        }
        return result
    }

    // CustomStringConvertible
    var _description: String {
        var result = ""
        self.cQueue.sync { [weak self] in
            result = self?.superDescription() ?? ""
        }
        return result
    }
        
    // MARK: Open Manipulating Functions
    func _append(_ elements: [T]) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superAppend(elements) }
    }
    
    func _append(_ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superAppend(element) }
    }
    
    func _prepend(_ elements: [T]) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superPrepend(elements) }
    }
    
    func _prepend(_ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superPrepend(element) }
    }
    
    func _replace(at idx: Int, _ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superReplace(at: idx, element) }
    }
    
    func _insert(_ element: T, at idx: Int) {
        self.cQueue.async(flags: .barrier) { [weak self] in
            self?.superInsert(element, at: idx)
        }
    }
        
    func _removeAll() {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemoveAll() }
    }
    
    func _removeFirst() {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemoveFirst() }
    }
    
    func _removeLast() {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemoveLast() }
    }
    
    func _remove(_ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemove(element) }
    }
    
    func _remove(at idx: Int) {
        self.cQueue.async(flags: .barrier) { [weak self] in self?.superRemove(at: idx) }
    }
    
    // MARK: Private Reading Functions
    func _index(_ element: T) -> Int? {
        var result: Int?
        self.cQueue.sync { [weak self] in
            result = self?.superIndex(element)
        }
        return result
    }
    
    func _getSubscript(idx: Int) -> T? {
        var result: T?
        self.cQueue.sync { [weak self] in result = self?.superSubscript(idx: idx) }
        return result
    }
    
    func _setSubscript(idx: Int, _ element: T) {
        self.cQueue.async(flags: .barrier) { [weak self] in
            self?.superSubscriptSet(idx: idx, element)
        }
    }
    
    func _find(at idx: Int) -> T? {
        var result: T?
        self.cQueue.sync { [weak self] in
            result = self?.superFind(at: idx)
        }
        return result
    }
    
    func _forEach(reversed: Bool, _ body: ((T) -> Void)) {
        self.cQueue.sync { [weak self] in
            self?.superForEach(reversed: reversed, body)
        }
    }
    
    func _enumerateObjects(reversed: Bool, _ body: ((_ obj: T, _ idx: Int, _ stop: inout Bool) -> Void)) {
        
        self.cQueue.sync { [weak self] in self?.superEnumerateObjects(reversed: reversed, body)
        }
    }

    func _printAllKeys(reversed: Bool) {
        self.cQueue.sync { [weak self] in self?.superPrintAllKeys(reversed: reversed)
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
    
    func superDescription() -> String { super.description }
    
    func superAppend(_ elements: [T]) { super.append(elements) }
    
    func superAppend(_ element: T) { super.append(element) }
    
    func superPrepend(_ elements: [T]) { super.prepend(elements) }
    
    func superPrepend(_ element: T) { super.prepend(element) }
    
    func superReplace(at idx: Int, _ element: T) { super.replace(at: idx, element) }
    
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

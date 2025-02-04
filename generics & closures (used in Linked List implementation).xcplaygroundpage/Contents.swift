//: [Previous](@previous)

import Foundation




class LinkedList<T> {
    
    // Internal Node Class
    private class ListNode<T> {
        var value: T
        var next: ListNode?
        var prev: ListNode?
        
        init(value: T, next: ListNode? = nil, prev: ListNode? = nil) {
            self.value = value
            self.next = next
            self.prev = prev
        }
        
    }
    
    private var head: ListNode<T>? = nil
    private var tail: ListNode<T>? = nil
    private var count: Int = 0
    
    // Computed properties for first and last values
    var first: T? { return head?.value }
    var last: T? { return tail?.value }
    var size: Int { return count }
    
    // Get node at a specific index
    private func at(_ index: Int) -> ListNode<T> {
        var current = head!
        for _ in 0..<index {
            current = current.next!
        }
        return current
    }
    
    // Append to the end
    func append(_ value: T) {
        let newTail = ListNode(value: value)
        if let existingTail = tail {
            existingTail.next = newTail
            newTail.prev = existingTail
        } else {
            head = newTail
        }
        tail = newTail
        count += 1
    }
    
    // Prepend to the beginning
    func prepend(_ value: T) {
        let newHead = ListNode(value: value)
        if let existingHead = head {
            existingHead.prev = newHead
            newHead.next = existingHead
        } else {
            tail = newHead
        }
        head = newHead
        count += 1
    }
    
    // Insert at specific index
    func insert(_ value: T, _ index: Int) {
        if index >= count {
            append(value)
        } else if index <= 0 {
            prepend(value)
        } else {
            let prev = at(index - 1)
            let next = prev.next!
            let newNode = ListNode(value: value, next: next, prev: prev)
            prev.next = newNode
            next.prev = newNode
            count += 1
        }
    }
    
    // Delete at specific index
    func delete(_ at index: Int) -> T? {
        if count == 0 || index >= count || index < 0 { return nil } // address nil cases
        
        let node = at(index)
        let value = node.value

        if node === head {
            head = node.next
            head?.prev = nil
        }
        if node === tail { // Head and tail could be the same if count == 1
            tail = node.prev
            tail?.next = nil
        } else {
            node.prev!.next = node.next
            node.next!.prev = node.prev
        }

        count -= 1
        return value
    }
    
    // Remove last element
    func popLast() -> T? {
        return count > 0 ? delete(count - 1) : nil
    }
    
    // Remove first element
    func popFirst() -> T? {
        return count > 0 ? delete(0) : nil
    }
    
    // Subscript access
    subscript(index: Int) -> T? {
        return at(index).value
    }
    
    // Display list contents
    func display() {
        var current = head
        var elements: [String] = []
        while let node = current {
            elements.append("\(node.value)")
            current = node.next
        }
        print("LinkedList: [\(elements.joined(separator: " <-> "))]")
    }
    // Finds all nodes that match the condition
    func find(where predicate: (T) -> Bool) -> [T] {
        var node = head
        var result: [T] = []
        
        while let currentNode = node {
            if predicate(currentNode.value) {
                result.append(currentNode.value)
            }
            node = currentNode.next
        }
        
        return result
    }

    // Finds the first node that matches the condition
    func findFirst(where predicate: (T) -> Bool) -> T? {
        var node = head
        
        while let currentNode = node {
            if predicate(currentNode.value) {
                return currentNode.value
            }
            node = currentNode.next
        }
        
        return nil
    }

    // Checks if a value exists in the list
    func contains(where predicate: (T) -> Bool) -> Bool {
        var node = head
        while let currentNode = node {
            if predicate(currentNode.value) {
                return true
            }
            node = currentNode.next
        }
        
        return false
    }
    
    func removeIf(_ condition: @autoclosure () -> Bool) {
        var node = head
        var i = 0
        while let currentNode = node {
            let nextNode = currentNode.next

            if condition() {
                delete(i)
            }
            i += 1

            node = nextNode  // Move to next
        }
    }
    
    func map(_ transform: (T) -> T) {
        var node = head
        while let currentNode = node {
            currentNode.value = transform(currentNode.value)
            node = currentNode.next
        }
    }
    
    func asyncMap(_ transform: @escaping (T) -> T) {
        DispatchQueue.global().async {
            var node = self.head
            while let currentNode = node {
                currentNode.value = transform(currentNode.value) // Now executes asynchronously
                node = currentNode.next
            }
        }
    }

}

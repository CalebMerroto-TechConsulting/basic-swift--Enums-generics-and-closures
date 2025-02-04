//: [Previous](@previous)

import Foundation




class LinkedList<T> {
    
    // Internal Node Class
    private class ListNode<U> {
        var value: U
        var next: ListNode?
        var prev: ListNode?
        
        init(value: U, next: ListNode? = nil, prev: ListNode? = nil) {
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
    func delete(_ index: Int) -> T? {
        if count == 0 || index >= count || index < 0 { return nil } // address nil cases
        
        var value: T?

        if index == 0 {
            let node = head
            value = node?.value
            head = node?.next
            head?.prev = nil
        }
        if index == count - 1 { // Head and tail could be the same if count == 1
            let node = tail
            value = node?.value
            tail = node?.prev
            tail?.next = nil
        } else if index != 0{
            let node = at(index)
            value = node.value
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
        // same as normal map for now
        var node = head
        while let currentNode = node {
            currentNode.value = transform(currentNode.value)
            node = currentNode.next
        }
    }

}


// Test LinkedList Implementation

print("\n=== LINKED LIST TEST CASES ===\n")

// Create a LinkedList of Integers
var intList = LinkedList<Int>()

// Test Append
print("\n--- Append Elements ---")
intList.append(10)
intList.append(20)
intList.append(30)
intList.append(40)
intList.append(50)
intList.display()  // Expected: [10 <-> 20 <-> 30 <-> 40 <-> 50]

// Test Prepend
print("\n--- Prepend Elements ---")
intList.prepend(5)
intList.prepend(2)
intList.display()  // Expected: [2 <-> 5 <-> 10 <-> 20 <-> 30 <-> 40 <-> 50]

// Test Insert
print("\n--- Insert Elements ---")
intList.insert(15, 3)
intList.insert(35, 6)
intList.display()  // Expected: [2 <-> 5 <-> 10 <-> 15 <-> 20 <-> 30 <-> 35 <-> 40 <-> 50]

// Test Delete
print("\n--- Delete Elements ---")
intList.delete(0)  // Remove first element
intList.delete(intList.size - 1)  // Remove last element
intList.delete(3)  // Remove middle element (20)
intList.display()  // Expected: [5 <-> 10 <-> 15 <-> 30 <-> 35 <-> 40]

// Test PopFirst and PopLast
print("\n--- Pop Elements ---")
print("First Popped:", intList.popFirst() ?? "None") // Expected: 5
print("Last Popped:", intList.popLast() ?? "None")   // Expected: 40
intList.display()  // Expected: [10 <-> 15 <-> 30 <-> 35]

// Test Contains
print("\n--- Contains Check ---")
print("List contains 15?", intList.contains { $0 == 15 }) // Expected: true
print("List contains 99?", intList.contains { $0 == 99 }) // Expected: false

// Test Find & FindFirst
print("\n--- Find Elements ---")
print("Find elements greater than 12:", intList.find { $0 > 12 })  // Expected: [15, 30, 35]
print("Find first element greater than 12:", intList.findFirst { $0 > 12 } ?? "None") // Expected: 15

// Test Map
print("\n--- Map Function ---")
intList.map { $0 * 2 }
intList.display()  // Expected: [20 <-> 30 <-> 60 <-> 70] (Doubled values)

// Test asyncMap
print("\n--- Async Map Function (Double values again) ---")
intList.asyncMap { $0 * 2 }

// Test RemoveIf using @autoclosure
print("\n--- Remove Elements Condition ---")
intList.removeIf(intList.contains { $0 > 100 })
intList.display()  // Expected: Removes values > 100

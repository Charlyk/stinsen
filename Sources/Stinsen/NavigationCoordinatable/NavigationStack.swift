import Foundation
import Combine
import SwiftUI

struct NavigationRootItem {
    let keyPath: Int
    let input: Any?
    let child: ViewPresentable
}

/// Wrapper around childCoordinators
/// Used so that you don't need to write @Published
public class NavigationRoot: ObservableObject {
    @Published var item: NavigationRootItem
    
    init(item: NavigationRootItem) {
        self.item = item
    }
}

/// Represents a stack of routes
public class NavigationStack<T: NavigationCoordinatable> {
    var dismissalAction: [Int: () -> Void] = [:]
    
    weak var parent: ChildDismissable?
    var poppedTo = PassthroughSubject<Int, Never>()
    let initial: PartialKeyPath<T>
    let initialInput: Any?
    var root: NavigationRoot!
    var coordinatableView: NavigationCoordinatableView<T>?
    
    @Published var value: [NavigationStackItem] {
        didSet {
            print("Stack value updated - \(value.count); \(String(describing: T.self));")
        }
    }
    
    public init(initial: PartialKeyPath<T>, _ initialInput: Any? = nil) {
        self.value = []
        self.initial = initial
        self.initialInput = initialInput
        self.root = nil
    }
    
    func getCoordinatableView(for coordinator: T) -> NavigationCoordinatableView<T> {
        if let coordinatableView = self.coordinatableView {
            return coordinatableView
        }
        
        self.coordinatableView = NavigationCoordinatableView(id: -1, coordinator: coordinator)
        return self.coordinatableView!
    }
    
    internal func topMostItem() -> NavigationStackItem? {
        guard let lastItem = value.last else {
            return nil
        }
        
        let coordinator = lastItem
        return coordinator
    }
}

/// Convenience checks against the navigation stack's contents
public extension NavigationStack {
    /**
        The Hash of the route at the top of the stack
        - Returns: the hash of the route at the top of the stack or -1
     */
    var currentRoute: Int {
        return value.last?.keyPath ?? -1
    }

    /**
    Checks if a particular KeyPath is in a stack
     - Parameter keyPathHash:The hash of the keyPath
     - Returns: Boolean indiacting whether the route is in the stack
     */
    func isInStack(_ keyPathHash: Int) -> Bool {
        return value.contains { $0.keyPath == keyPathHash }
    }
}

struct NavigationStackItem {
    let presentationType: PresentationType
    let presentable: ViewPresentable
    let keyPath: Int
    let input: Any?
}

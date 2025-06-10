import Foundation

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T {
        do {
            return try DependenciesContainer.shared.resolve(T.self)
        } catch {
            preconditionFailure("Failed to resolve \(T.self): \(error)")
        }
    }
}

protocol IDependenciesContainer {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func resolve<T>(_ type: T.Type) throws -> T
}

final class DependenciesContainer: IDependenciesContainer {
    static let shared = DependenciesContainer()

    private var services: [ObjectIdentifier: () -> Any] = [:]

    private init() {}

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        services[ObjectIdentifier(T.self)] = factory
    }

    func resolve<T>(_ type: T.Type) throws -> T {
        guard let factory = services[ObjectIdentifier(T.self)] else {
            throw DependenciesContainerError.notRegistered(String(describing: T.self))
        }
        guard let instance = factory() as? T else {
            throw DependenciesContainerError.notRegistered("Invalid type cast for \(T.self)")
        }
        return instance
    }

    func reset() {
        services.removeAll()
    }

    enum DependenciesContainerError: Error {
        case notRegistered(String)
    }
}

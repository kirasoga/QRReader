import Foundation

public extension String {
    func shortString() -> String {
        return "\(self.prefix(10))..."
    }
}

public class MyClass {
    public init() {}

    public var a = 2
}

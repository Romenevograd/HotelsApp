import Foundation

public extension String {
    func localized(with arguments: any CVarArg...) -> String {
        String(
            format: NSLocalizedString(self, comment: ""),
            locale: nil,
            arguments: arguments
        )
    }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

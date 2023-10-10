import Clibgit2

public struct Branch {
    /// The full name of the reference (e.g., `refs/heads/master`).
    public let longName: String

    /// The short human-readable name of the branch (e.g., `master`).
    public let name: String

    public init(
        longName: String,
        name: String
    ) {
        self.longName = longName
        self.name = name
    }
}

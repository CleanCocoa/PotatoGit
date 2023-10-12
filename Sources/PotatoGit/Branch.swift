import Clibgit2

public final class Branch {
    internal let branchPtr: OpaquePointer

    /// The full name of the reference (e.g., `refs/heads/master`).
    public let longName: String

    /// The short human-readable name of the branch (e.g., `master`).
    public let name: String

    public let repository: Repository

    internal init(
        branchPtr: OpaquePointer,
        longName: String,
        name: String,
        repository: Repository
    ) {
        self.branchPtr = branchPtr
        self.longName = longName
        self.name = name
        self.repository = repository
    }

    deinit {
        git_reference_free(branchPtr)
    }
}


import Clibgit2

public final class Branch {
    internal let branchPtr: OpaquePointer

    /// The full name of the reference (e.g., `refs/heads/master`).
    public let longName: String

    /// The short human-readable name of the branch (e.g., `master`).
    public let name: String

    internal init(
        branchPtr: OpaquePointer,
        longName: String,
        name: String
    ) {
        self.branchPtr = branchPtr
        self.longName = longName
        self.name = name
    }

    deinit {
        git_reference_free(branchPtr)
    }
}


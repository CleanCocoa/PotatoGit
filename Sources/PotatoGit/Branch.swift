import Clibgit2

public struct Branch {
    /// The full name of the reference (e.g., `refs/heads/master`).
    public let longName: String

    /// The short human-readable name of the branch (e.g., `master`).
    public let name: String

    /// Given a reference object, this will check that it really is a branch (ie. it lives under “refs/heads/” or “refs/remotes/”), and return the branch part of it.
    internal init?(
        branchPtr: OpaquePointer
    ) {
        var namePointer: UnsafePointer<Int8>? = nil
        guard git_branch_name(&namePointer, branchPtr) == GIT_OK.rawValue else {
            return nil
        }
        self.name = String(validatingUTF8: namePointer!)!
        self.longName = String(validatingUTF8: git_reference_name(branchPtr))!
    }
}

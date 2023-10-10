import Clibgit2

extension Remote {
    public func branch(
        named name: String
    ) -> Result<Branch?, PotatoGitError> {
        let referenceName = "refs/remotes/" + name

        var pointer: OpaquePointer? = nil
        defer { if let pointer { git_reference_free(pointer) } }

        let result = git_reference_lookup(&pointer, self.repository.repositoryPtr, referenceName)

        switch result {
        case GIT_OK.rawValue:
            return .success(Branch(branchPtr: pointer!))

        case GIT_ENOTFOUND.rawValue:
            return .success(nil)

        default:
            return .failure(.unexpected(gitError: result, pointOfFailure: "git_reference_lookup"))
        }
    }
}

extension Branch {
    /// Given a reference object, this will check that it really is a branch (i.e. it lives under “refs/heads/” or “refs/remotes/”), and return the branch part of it.
    fileprivate init?(
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

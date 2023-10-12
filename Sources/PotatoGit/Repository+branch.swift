import Clibgit2

extension Repository {
    public func branch(
        named branchName: String,
        local: Bool = true
    ) -> Result<Branch?, PotatoGitError> {
        let referenceName = "refs/\(local ? "heads" : "remotes")/\(branchName)"

        var pointer: OpaquePointer? = nil

        let result = git_reference_lookup(&pointer, self.repositoryPtr, referenceName)

        switch result {
        case GIT_OK.rawValue:
            return .success(Branch(branchPtr: pointer!))

        case GIT_ENOTFOUND.rawValue:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            return .success(nil)

        default:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            return .failure(.unexpected(gitError: result, pointOfFailure: "git_reference_lookup"))
        }
    }
}

extension Branch {
    convenience init?(
        branchPtr: OpaquePointer
    ) {
        var namePointer: UnsafePointer<Int8>? = nil
        guard git_branch_name(&namePointer, branchPtr) == GIT_OK.rawValue else {
            git_reference_free(branchPtr)
            return nil
        }
        self.init(
            branchPtr: branchPtr,
            longName: String(validatingUTF8: git_reference_name(branchPtr))!,
            name: String(validatingUTF8: namePointer!)!
        )
    }
}

import Clibgit2

extension Branch {
    public func reset(
        to commitString: String
    ) throws {
        let oid = try OID(string: commitString)

        var pointer: OpaquePointer?
        defer { if let pointer { git_reference_free(pointer) } }

        let result = withUnsafePointer(to: oid.oid) { oidPtr in
            git_reference_set_target(
                &pointer,
                self.branchPtr,
                oidPtr,
                "reset: moving \(self.name) to point to \(commitString)"
            )
        }

        switch result {
        case GIT_OK.rawValue:
            return

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git")
        }
    }
}

import Clibgit2

extension Repository {
    public func checkout(
        commit string: String,
        strategy: CheckoutStrategy = .safe
    ) throws {
        try checkout(
            commit: OID(string: string),
            strategy: strategy
        )
    }

    public func checkout(
        commit oid: OID,
        strategy: CheckoutStrategy = .safe
    ) throws {
        let result = withUnsafePointer(to: oid.oid) { oidPtr in
            git_repository_set_head_detached(self.repositoryPtr, oidPtr)
        }

        switch result {
        case GIT_OK.rawValue:
            return

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_repository_set_head_detached")
        }
    }

    public func checkout(
        branch: Branch,
        strategy: CheckoutStrategy
    ) throws {
        try changeHEAD(to: branch)

        let result = withUnsafePointer(to: checkoutOptions(strategy: strategy)) { optionsPtr in
            git_checkout_head(self.repositoryPtr, optionsPtr)
        }

        switch result {
        case GIT_OK.rawValue:
            return

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_checkout_head")
        }
    }

    private func changeHEAD(
        to branch: Branch
    ) throws {
        let result = git_repository_set_head(self.repositoryPtr, branch.longName)

        switch result {
        case GIT_OK.rawValue:
            return

        case GIT_ENOTFOUND.rawValue:
            throw PotatoGitError.notFound(branch.longName)

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_repository_set_head")
        }
    }
}

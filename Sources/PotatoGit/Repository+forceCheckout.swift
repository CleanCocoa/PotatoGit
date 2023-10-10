import Foundation
import Clibgit2

extension Repository {
    public func checkout(
        remote: Remote,
        branch: Branch,
        strategy: CheckoutStrategy
    ) throws {
        try changeHEAD(to: branch)

        var options = checkoutOptions(strategy: strategy)

        let result = git_checkout_head(self.repositoryPtr, &options)

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

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_repository_set_head")
        }
    }
}

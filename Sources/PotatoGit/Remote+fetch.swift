import Clibgit2

extension Remote {
    public func fetch() throws {
        let result = git_remote_fetch(self.remotePtr, nil, nil, nil)

        switch result {
        case GIT_OK.rawValue:
            return

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_remote_fetch")
        }
    }
}

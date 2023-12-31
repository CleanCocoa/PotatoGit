import Foundation
import Clibgit2

extension Repository {
    /// - Parameter name: The remote's name.
    /// - Returns: A ``Remote`` if the reference has been found, `nil` if it hasn't, or an error.
    public func remote(
        named name: String
    ) throws -> Remote? {
        var pointer: OpaquePointer? = nil

        let result = git_remote_lookup(&pointer, self.repositoryPtr, name)

        switch result {
        case GIT_OK.rawValue:
            return Remote(remotePtr: pointer!, repository: self)

        case GIT_ENOTFOUND.rawValue:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            return nil

        default:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_remote_lookup")
        }
    }
}

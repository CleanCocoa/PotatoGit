import Foundation
import Clibgit2

extension Repository {
    public static func exists(at url: URL) throws -> Bool {
        git_libgit2_init()
        defer { git_libgit2_shutdown() }

        var pointer: OpaquePointer?

        let result = url.withUnsafeFileSystemRepresentation {
            git_repository_open_ext(&pointer, $0, GIT_REPOSITORY_OPEN_NO_SEARCH.rawValue, nil)
        }

        switch result {
        case GIT_ENOTFOUND.rawValue:
            return false

        case GIT_OK.rawValue:
            return true

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_repository_open_ext")
        }
    }
}

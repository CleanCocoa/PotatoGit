import Foundation
import Clibgit2

extension Repository {
    /// Load the repository at the given file URL.
    /// - Parameter localURL: The file URL of the repository. This must point to either a git repository folder, or an existing work dir.
    /// - Returns: The opened ``Repository`` or an error.
    public static func open(
        at localURL: URL
    ) throws -> Repository{
        git_libgit2_init()
        defer { git_libgit2_shutdown() }

        var pointer: OpaquePointer? = nil
        let result = localURL.withUnsafeFileSystemRepresentation {
            git_repository_open(&pointer, $0)
        }

        guard result == GIT_OK.rawValue else {
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_repository_open")
        }

        return Repository(repositoryPtr: pointer!)
    }
}

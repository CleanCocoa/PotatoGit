import Foundation
import Clibgit2

public final class Repository {
    internal let repositoryPtr: OpaquePointer

    /// The URL of the repository's working directory, or `nil` if the repository is bare.
    public let directoryURL: URL?

    internal init(repositoryPtr: OpaquePointer) {
        git_libgit2_init()

        self.repositoryPtr = repositoryPtr

        let path = git_repository_workdir(repositoryPtr)
        self.directoryURL = path.map { URL(fileURLWithPath: String(validatingUTF8: $0)!, isDirectory: true) }
    }

    deinit {
        git_repository_free(repositoryPtr)
        git_libgit2_shutdown()
    }
}

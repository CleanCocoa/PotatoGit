import Foundation
import Clibgit2

public final class Repository {
    internal let repositoryPtr: OpaquePointer

    internal init(repositoryPtr: OpaquePointer) {
        git_libgit2_init()
        self.repositoryPtr = repositoryPtr
    }

    deinit {
        git_repository_free(repositoryPtr)
        git_libgit2_shutdown()
    }
}

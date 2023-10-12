import Foundation
import Clibgit2

extension Repository {
    public static func clone(
        from remoteURL: URL,
        to localURL: URL,
        bare: Bool = false,
        checkoutStrategy: CheckoutStrategy = .safe
    ) throws -> Repository {
        git_libgit2_init()
        defer { git_libgit2_shutdown() }

        var options = cloneOptions(
            bare: bare,
            localClone: false,
            fetchOptions: fetchOptions(),
            checkoutOptions: checkoutOptions(strategy: checkoutStrategy))

        var pointer: OpaquePointer? = nil
        let remoteURLString = (remoteURL as NSURL).isFileReferenceURL() ? remoteURL.path : remoteURL.absoluteString
        let result = localURL.withUnsafeFileSystemRepresentation { localPath in
            git_clone(&pointer, remoteURLString, localPath, &options)
        }

        guard result == GIT_OK.rawValue else {
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_clone")
        }

        return Repository(repositoryPtr: pointer!)
    }
}

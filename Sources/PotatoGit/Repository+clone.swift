import Foundation
import Clibgit2

extension Repository {
    public static func clone(
        from remoteURL: URL,
        to localURL: URL,
        bare: Bool = false,
        checkoutStrategy: CheckoutStrategy = .safe
    ) -> Result<Repository, PotatoGitError> {
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
            return .failure(.unexpected(gitError: result, pointOfFailure: "git_clone"))
        }

        let repository = Repository(repositoryPtr: pointer!)
        return Result.success(repository)
    }
}

private func cloneOptions(
    bare: Bool = false,
    localClone: Bool = false,
    fetchOptions: git_fetch_options? = nil,
    checkoutOptions: git_checkout_options? = nil
) -> git_clone_options {
    let pointer = UnsafeMutablePointer<git_clone_options>.allocate(capacity: 1)
    defer { pointer.deallocate() }

    git_clone_init_options(pointer, UInt32(GIT_CLONE_OPTIONS_VERSION))

    var options = pointer.move()

    options.bare = bare ? 1 : 0

    if localClone {
        options.local = GIT_CLONE_NO_LOCAL
    }

    if let checkoutOptions = checkoutOptions {
        options.checkout_opts = checkoutOptions
    }

    if let fetchOptions = fetchOptions {
        options.fetch_opts = fetchOptions
    }

    return options
}

private func checkoutOptions(strategy: CheckoutStrategy) -> git_checkout_options {
    let pointer = UnsafeMutablePointer<git_checkout_options>.allocate(capacity: 1)
    defer { pointer.deallocate() }

    git_checkout_init_options(pointer, UInt32(GIT_CHECKOUT_OPTIONS_VERSION))

    var options = pointer.move()

    options.checkout_strategy = strategy.gitCheckoutStrategy.rawValue

    return options
}

private func fetchOptions() -> git_fetch_options {
    let pointer = UnsafeMutablePointer<git_fetch_options>.allocate(capacity: 1)
    defer { pointer.deallocate() }

    git_fetch_init_options(pointer, UInt32(GIT_FETCH_OPTIONS_VERSION))

    return pointer.move()
}

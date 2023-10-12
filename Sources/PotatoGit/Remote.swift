import Clibgit2

public final class Remote {
    internal let remotePtr: OpaquePointer

    /// The remote's repository.
    public let repository: Repository

    /// The name of the remote.
    public let name: String

    /// The URL of the remote.
    public let urlString: String

    internal init(
        remotePtr: OpaquePointer,
        repository: Repository,
        name: String,
        urlString: String
    ) {
        self.remotePtr = remotePtr
        self.repository = repository
        self.name = name
        self.urlString = urlString
    }

    deinit {
        git_remote_free(remotePtr)
    }
}

extension Remote {
    internal convenience init(
        remotePtr: OpaquePointer,
        repository: Repository
    ) {
        self.init(
            remotePtr: remotePtr,
            repository: repository,
            name: String(validatingUTF8: git_remote_name(remotePtr))!,
            urlString: String(validatingUTF8: git_remote_url(remotePtr))!
        )
    }
}

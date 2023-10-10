import Clibgit2

public struct Remote {
    /// The remote's repository.
    public let repository: Repository

    /// The name of the remote.
    public let name: String

    /// The URL of the remote.
    public let urlString: String

    internal init(
        remotePtr: OpaquePointer,
        repository: Repository
    ) {
        self.name = String(validatingUTF8: git_remote_name(remotePtr))!
        self.urlString = String(validatingUTF8: git_remote_url(remotePtr))!
        self.repository = repository
    }
}

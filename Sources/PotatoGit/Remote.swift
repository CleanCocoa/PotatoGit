import Clibgit2

public struct Remote {
    /// The name of the remote.
    public let name: String

    /// The URL of the remote.
    public let urlString: String

    internal init(_ pointer: OpaquePointer) {
        self.name = String(validatingUTF8: git_remote_name(pointer))!
        self.urlString = String(validatingUTF8: git_remote_url(pointer))!
    }
}

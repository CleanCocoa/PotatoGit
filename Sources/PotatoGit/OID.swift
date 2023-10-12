import Clibgit2

/// Git object identifier of commit, tree, blob, or tag.
public struct OID {
    public let oid: git_oid

    public init(_ oid: git_oid) {
        self.oid = oid
    }
}

extension OID {
    /// - Parameter string: A hex formatted string. 40 bytes for SHA1, 64 bytes for SHA256.
    public init(string: String) throws {
        let pointer = UnsafeMutablePointer<git_oid>.allocate(capacity: 1)
        defer { pointer.deallocate() }

        let result = git_oid_fromstr(pointer, string)

        switch result {
        case GIT_OK.rawValue:
            self.oid = pointer.pointee

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_oid_fromstr")
        }
    }
}

extension OID {
    init(copying oid: UnsafePointer<git_oid>!) throws {
        let pointer = UnsafeMutablePointer<git_oid>.allocate(capacity: 1)
        defer { pointer.deallocate() }

        let result = git_oid_cpy(pointer, oid)

        switch result {
        case GIT_OK.rawValue:
            self.oid = pointer.pointee

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_oid_fromstr")
        }
    }
}


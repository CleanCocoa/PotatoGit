import Clibgit2
import Foundation

extension Branch {
    public func isOutdated(
        comparedAgainst referenceBranch: Branch
    ) throws -> Bool {
        guard let localTip = try self.tip(),
              let upstreamTip = try referenceBranch.tip()
        else { return false }

        var ahead = 0
        var behind = 0

        let result = withUnsafePointer(to: localTip.oid) { localTipOIDPtr in
            withUnsafePointer(to: upstreamTip.oid) { upstreamTipOIDPtr in
                git_graph_ahead_behind(
                    &ahead,
                    &behind,
                    self.repository.repositoryPtr,
                    localTipOIDPtr,
                    upstreamTipOIDPtr
                )
            }
        }

        switch result {
        case GIT_OK.rawValue:
            return behind != 0

        default:
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_graph_ahead_behind")
        }
    }

    public func isOutdated() throws -> Bool {
        guard let upstream = try self.upstream()
        else { return false }
        return try isOutdated(comparedAgainst: upstream)
    }

    public func tip() throws -> OID? {
        var pointer: OpaquePointer?
        defer { if let pointer { git_object_free(pointer) } }

        let result = git_revparse_single(
            &pointer,
            self.repository.repositoryPtr,
            self.longName
        )

        switch result {
        case GIT_OK.rawValue:
            // FIXME: Is copy constructor needed, or can we just keep the returned git_oid because it's a value type anyway?
            return try OID(copying: git_commit_id(pointer))

        case GIT_ENOTFOUND.rawValue:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            return nil

        default:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_branch_upstream")
        }
    }

    fileprivate func upstream() throws -> Branch? {
        var upstreamBranchPtr: OpaquePointer?

        let result = git_branch_upstream(&upstreamBranchPtr, self.branchPtr)

        switch result {
        case GIT_OK.rawValue:
            return Branch(branchPtr: upstreamBranchPtr!, repository: self.repository)

        case GIT_ENOTFOUND.rawValue:
            precondition(upstreamBranchPtr == nil, "Did not expect pointer to be allocated for non-success case")
            return nil

        default:
            precondition(upstreamBranchPtr == nil, "Did not expect pointer to be allocated for non-success case")
            throw PotatoGitError.unexpected(gitError: result, pointOfFailure: "git_branch_upstream")
        }
    }
}

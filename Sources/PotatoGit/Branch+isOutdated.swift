import Clibgit2
import Foundation

extension Branch {
    public func isOutdated(
        comparedAgainst referenceBranch: Branch
    )  -> Result<Bool, PotatoGitError> {
        return self.tip.flatMap { localTip in
            guard let localTip else { return .success(false) }

            return referenceBranch.tip.flatMap { upstreamTip in
                guard let upstreamTip else { return .success(false) }

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
                    return .success(behind != 0)

                default:
                    return .failure(.unexpected(gitError: result, pointOfFailure: "git_graph_ahead_behind"))
                }
            }
        }
    }

    public func isOutdated() -> Result<Bool, PotatoGitError> {
        return self.upstream.flatMap { upstream in
            guard let upstream else { return .success(false) }
            return isOutdated(comparedAgainst: upstream)
        }
    }

    var tip: Result<OID?, PotatoGitError> {
        var pointer: OpaquePointer?
        defer { if let pointer { git_object_free(pointer) } }

        let result = git_revparse_single(
            &pointer,
            self.repository.repositoryPtr,
            self.longName
        )

        switch result {
        case GIT_OK.rawValue:
            do {
                // FIXME: Is copy constructor needed, or can we just keep the returned git_oid because it's a value type anyway?
                return .success(try OID(copying: git_commit_id(pointer)))
            } catch {
                return .failure(.unexpected(error as NSError))
            }

        case GIT_ENOTFOUND.rawValue:
            return .success(nil)

        default:
            precondition(pointer == nil, "Did not expect pointer to be allocated for non-success case")
            return .failure(.unexpected(gitError: result, pointOfFailure: "git_branch_upstream"))
        }
    }

    var upstream: Result<Branch?, PotatoGitError> {
        var upstreamBranchPtr: OpaquePointer?

        let result = git_branch_upstream(&upstreamBranchPtr, self.branchPtr)

        switch result {
        case GIT_OK.rawValue:
            return .success(Branch(branchPtr: upstreamBranchPtr!, repository: self.repository))

        case GIT_ENOTFOUND.rawValue:
            precondition(upstreamBranchPtr == nil, "Did not expect pointer to be allocated for non-success case")
            return .success(nil)

        default:
            precondition(upstreamBranchPtr == nil, "Did not expect pointer to be allocated for non-success case")
            return .failure(.unexpected(gitError: result, pointOfFailure: "git_branch_upstream"))
        }
    }
}

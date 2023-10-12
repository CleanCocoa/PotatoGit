import Clibgit2

extension Remote {
    public func branch(
        named branchName: String
    ) -> Result<Branch?, PotatoGitError> {
        return self.repository.branch(
            named: "\(self.name)/\(branchName)",
            local: false
        )
    }
}

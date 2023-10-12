import Clibgit2

extension Remote {
    public func branch(
        named branchName: String
    ) throws -> Branch? {
        return try self.repository.branch(
            named: "\(self.name)/\(branchName)",
            local: false
        )
    }
}

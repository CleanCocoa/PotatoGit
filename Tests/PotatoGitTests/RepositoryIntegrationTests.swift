import XCTest
import PotatoGit

extension URL {
    fileprivate var canonicalPathComponents: [String] {
        var components = self.resolvingSymlinksInPath().pathComponents
        // E.g. `/private/var` and `/var` are treated equally
        if components.count > 0 && components[1] == "private" {
            components.remove(at: 1)
        }
        return components
    }
}

final class RepositoryIntegrationTests: XCTestCase {
    let localURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("de.christiantietze.potatogit")
        .appendingPathComponent("tests")
    let remoteURL = URL(string: "https://github.com/CleanCocoa/PotatoGit")!

    private func removeLocalRepositoryFolderIfNeeded() throws {
        if FileManager.default.fileExists(atPath: localURL.path(percentEncoded: false)) {
            try FileManager.default.removeItem(at: localURL)
        }
    }

    override func setUpWithError() throws {
        try removeLocalRepositoryFolderIfNeeded()
        try FileManager.default.createDirectory(at: localURL, withIntermediateDirectories: true)

        // Preconditions
        XCTAssertFalse(try Repository.exists(at: localURL))
    }

    override func tearDownWithError() throws {
        try removeLocalRepositoryFolderIfNeeded()
    }

    func testCloningSetsDirectoryURL() throws {
        let repo = try Repository.clone(from: remoteURL, to: localURL)

        XCTAssertTrue(try Repository.exists(at: localURL))
        XCTAssertEqual(repo.directoryURL?.canonicalPathComponents, localURL.canonicalPathComponents)
    }

    func testOpeningClonedGitRepositorySetsDirectoryURL() throws {
        XCTAssertNoThrow(try Repository.clone(from: remoteURL, to: localURL))

        let repo = try Repository.open(at: localURL)

        XCTAssertEqual(repo.directoryURL?.canonicalPathComponents, localURL.canonicalPathComponents)
    }

    func testForceCheckout() throws {
        let repository = try Repository.clone(from: remoteURL, to: localURL)
        let origin = try XCTUnwrap(repository.remote(named: "origin"))
        let remoteMainBranch = try XCTUnwrap(origin.branch(named: "main"))

        // Delete the LICENSE file to make the repo dirty.
        let licenseFileURL = localURL.appending(path: "LICENSE")
        XCTAssertTrue(FileManager.default.fileExists(atPath: licenseFileURL.path(percentEncoded: false)))
        try FileManager.default.removeItem(at: licenseFileURL)
        XCTAssertFalse(FileManager.default.fileExists(atPath: licenseFileURL.path(percentEncoded: false)))

        try repository.checkout(
            branch: remoteMainBranch,
            strategy: .force
        )

        XCTAssertTrue(FileManager.default.fileExists(atPath: licenseFileURL.path(percentEncoded: false)),
                      "LICENSE file should have been restored")
    }

    func testRemoteTrackingBranchIsOutdated() throws {
        let repository = try Repository.clone(from: remoteURL, to: localURL)
        let mainBranch = try XCTUnwrap(repository.branch(named: "main"))

        XCTAssertFalse(try mainBranch.isOutdated())

        try repository.checkout(commit: "7dcff510c4a8e4aeda68212ac4cc776db998175e")
        try mainBranch.reset(to: "7dcff510c4a8e4aeda68212ac4cc776db998175e")

        XCTAssertTrue(try mainBranch.isOutdated())
    }
}

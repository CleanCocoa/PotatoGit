import XCTest
import PotatoGit

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
    }

    override func tearDownWithError() throws {
        try removeLocalRepositoryFolderIfNeeded()
    }

    func testCloningPotatoGitRepository() throws {
        XCTAssertFalse(try Repository.exists(at: localURL).get())
        XCTAssertThrowsError(try Repository.open(at: localURL).get())

        XCTAssertNoThrow(try Repository.clone(from: remoteURL, to: localURL).get())

        XCTAssertTrue(try Repository.exists(at: localURL).get())
        XCTAssertNoThrow(try Repository.open(at: localURL).get())
    }

    func testForceCheckout() throws {
        let repository = try Repository.clone(from: remoteURL, to: localURL).get()
        let origin = try XCTUnwrap(repository.remote(named: "origin").get())
        let mainBranch = try XCTUnwrap(origin.branch(named: "main").get())

        // Delete the LICENSE file to make the repo dirty.
        let licenseFileURL = localURL.appending(path: "LICENSE")
        XCTAssertTrue(FileManager.default.fileExists(atPath: licenseFileURL.path(percentEncoded: false)))
        try FileManager.default.removeItem(at: licenseFileURL)
        XCTAssertFalse(FileManager.default.fileExists(atPath: licenseFileURL.path(percentEncoded: false)))

        try repository.checkout(
            remote: origin,
            branch: mainBranch,
            strategy: .force
        )

        XCTAssertTrue(FileManager.default.fileExists(atPath: licenseFileURL.path(percentEncoded: false)),
                      "LICENSE file should have been restored")
    }
}

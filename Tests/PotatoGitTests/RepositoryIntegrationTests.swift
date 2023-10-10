import XCTest
@testable import PotatoGit

final class RepositoryIntegrationTests: XCTestCase {
    let localURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("de.christiantietze.potatogit")
        .appendingPathComponent("tests")
    let remoteURL = URL(string: "https://github.com/CleanCocoa/PotatoGit")!

    override func setUpWithError() throws {
        if FileManager.default.fileExists(atPath: localURL.path(percentEncoded: false)) {
            try FileManager.default.removeItem(at: localURL)
        }
        try FileManager.default.createDirectory(at: localURL, withIntermediateDirectories: true)
    }

    func testCloningPotatoGitRepository() throws {
        XCTAssertFalse(try Repository.exists(at: localURL).get())

        XCTAssertNoThrow(try Repository.clone(from: remoteURL, to: localURL).get())

        XCTAssertTrue(try Repository.exists(at: localURL).get())
    }
}

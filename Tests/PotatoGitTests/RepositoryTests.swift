import XCTest
@testable import PotatoGit

final class RepositoryTests: XCTestCase {
    let nonExistingPath = URL(filePath: "/tmp/path/does_not/exist/20231010101029")

    func testExists_PathNotFound_ReturnsFalse() throws {
        XCTAssertFalse(try Repository.exists(at: nonExistingPath))
    }

    func testOpen_PathNotFound_Throws() throws {
        XCTAssertThrowsError(try Repository.open(at: nonExistingPath))
    }
}

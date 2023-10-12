import XCTest
@testable import PotatoGit

final class RepositoryTests: XCTestCase {
    func testExists_PathNotFound_ReturnsFalse() throws {
        XCTAssertFalse(try Repository.exists(at: URL(filePath: "/tmp/path/does_not/exist/20231010101029")))
    }
}

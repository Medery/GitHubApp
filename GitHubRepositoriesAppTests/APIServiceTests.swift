
import XCTest
@testable import GitHubRepositoriesApp

class APIServiceTests: XCTestCase {
    func testFetchData_Success() async throws {
        let json = """
        {
            "total_count": 1,
            "incomplete_results": false,
            "items": [
                {
                    "id": 1,
                    "name": "TestRepo",
                    "full_name": "TestUser/TestRepo",
                    "description": "A test repository",
                    "stargazers_count": 100,
                    "owner": {
                        "login": "TestUser",
                        "avatar_url": "https://example.com/avatar.png"
                    }
                }
            ]
        }
        """.data(using: .utf8)!

        let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=1")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let session = URLSessionMock(data: json, response: response, error: nil)
        let apiService = APIService(session: session, token: "dummy_token")

        let data = try await apiService.fetchData(url: url)
        XCTAssertEqual(data, json)
    }

    func testFetchData_Failure() async {
        let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=1")!
        let session = URLSessionMock(data: nil, response: nil, error: APIError.requestFailed)
        let apiService = APIService(session: session, token: "dummy_token")

        do {
            _ = try await apiService.fetchData(url: url)
            XCTFail("Expected to throw, but did not")
        } catch {
            XCTAssertEqual(error as? APIError, APIError.requestFailed)
        }
    }
}

class URLSessionMock: URLSessionProtocol {
    let data: Data?
    let response: URLResponse?
    let error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw APIError.requestFailed
        }
        return (data, response)
    }
}

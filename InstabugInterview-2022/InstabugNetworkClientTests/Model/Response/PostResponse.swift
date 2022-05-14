// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let postResponse = try? newJSONDecoder().decode(PostResponse.self, from: jsonData)

import Foundation

// MARK: - PostResponse
struct PostResponse: Codable {

    let origin: String
    let url: String

    enum CodingKeys: String, CodingKey {

        case origin, url
    }
}


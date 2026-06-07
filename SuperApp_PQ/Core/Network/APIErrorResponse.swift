//
//  APIErrorResponse.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation

// MARK: - APIErrorResponse

/// Generic DTO for structured error bodies returned by the server.
/// Adapt `CodingKeys` to match your backend's actual field names.
///
/// Example server response:
/// ```json
/// {
///   "code":    "EMAIL_ALREADY_EXISTS",
///   "message": "Email này đã được đăng ký.",
///   "errors": [
///     { "field": "email", "message": "Already taken" }
///   ]
/// }
/// ```
struct APIErrorResponse: Sendable {
    let code:    String?
    let message: String?
    let errors:  [APIFieldError]?

    /// Human-readable message: prefers `message`, falls back to `code`.
    var displayMessage: String {
        message ?? code ?? "Đã có lỗi xảy ra từ máy chủ."
    }
}

// MARK: - APIFieldError

struct APIFieldError: Sendable {
    let field:   String?
    let message: String?
}

// MARK: - Decodable (nonisolated — avoid MainActor isolation)

extension APIErrorResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case code, message, errors
    }

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code    = try container.decodeIfPresent(String.self,          forKey: .code)
        message = try container.decodeIfPresent(String.self,          forKey: .message)
        errors  = try container.decodeIfPresent([APIFieldError].self, forKey: .errors)
    }
}

extension APIFieldError: Decodable {
    private enum CodingKeys: String, CodingKey {
        case field, message
    }

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        field   = try container.decodeIfPresent(String.self, forKey: .field)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}

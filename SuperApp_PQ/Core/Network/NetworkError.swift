//
//  NetworkError.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import Alamofire

// MARK: - NetworkError

enum NetworkError: Error {

    // ── Connectivity ──────────────────────────────────
    /// No active internet connection.
    case noInternet
    /// Request exceeded the timeout interval.
    case timeout
    /// Request was explicitly cancelled.
    case cancelled

    // ── Client Errors (4xx) ───────────────────────────
    /// 400 — Server rejected the request (validation, bad params).
    case badRequest
    /// 401 — Access token missing or expired.
    case unauthorized
    /// 403 — Authenticated but not allowed.
    case forbidden
    /// 404 — Resource not found.
    case notFound
    /// 409 — Resource conflict (e.g. duplicate email).
    case conflict
    /// 422 — Unprocessable entity (semantic validation failed).
    case unprocessableEntity
    /// 429 — Too many requests, rate limited.
    case tooManyRequests

    // ── Server Errors (5xx) ───────────────────────────
    /// 500 — Internal server error.
    case internalServerError
    /// 503 — Server temporarily unavailable (maintenance).
    case serviceUnavailable
    /// Any other 5xx status code.
    case serverError(statusCode: Int)

    // ── Data Errors ───────────────────────────────────
    /// Server returned a structured error body (code + message).
    case apiError(APIErrorResponse)
    /// JSON decoding of the success response failed.
    case decodingFailed(Error)

    // ── Fallback ──────────────────────────────────────
    /// Catch-all for unexpected errors.
    case unknown(Error)
}

// MARK: - Computed Properties

extension NetworkError {

    /// User-facing error message.
    var message: String {
        switch self {
        case .noInternet:
            return "Không có kết nối mạng. Vui lòng kiểm tra lại."
        case .timeout:
            return "Kết nối quá thời gian. Vui lòng thử lại."
        case .cancelled:
            return "Yêu cầu đã bị huỷ."
        case .badRequest:
            return "Yêu cầu không hợp lệ."
        case .unauthorized:
            return "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại."
        case .forbidden:
            return "Bạn không có quyền thực hiện thao tác này."
        case .notFound:
            return "Không tìm thấy tài nguyên yêu cầu."
        case .conflict:
            return "Dữ liệu đã tồn tại. Vui lòng kiểm tra lại."
        case .unprocessableEntity:
            return "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại."
        case .tooManyRequests:
            return "Bạn thao tác quá nhanh. Vui lòng chờ và thử lại."
        case .internalServerError:
            return "Lỗi máy chủ. Vui lòng thử lại sau."
        case .serviceUnavailable:
            return "Hệ thống đang bảo trì. Vui lòng thử lại sau."
        case .serverError(let code):
            return "Lỗi máy chủ (\(code)). Vui lòng thử lại sau."
        case .apiError(let response):
            return response.displayMessage
        case .decodingFailed:
            return "Lỗi đọc dữ liệu phản hồi."
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    var isUnauthorized: Bool {
        if case .unauthorized = self { return true }
        return false
    }

    var isNoInternet: Bool {
        if case .noInternet = self { return true }
        return false
    }

    var isCancelled: Bool {
        if case .cancelled = self { return true }
        return false
    }

    var isServerError: Bool {
        switch self {
        case .internalServerError, .serviceUnavailable, .serverError: return true
        default: return false
        }
    }
}

// MARK: - Factory

extension NetworkError {

    /// Maps an Alamofire error + HTTP status code + optional raw response data to a typed `NetworkError`.
    /// Priority:
    ///   1. Try to decode `APIErrorResponse` from response body (server structured error).
    ///   2. Map by HTTP status code.
    ///   3. Map URLError (connectivity).
    ///   4. Map decoding failure.
    ///   5. Fall through to `.unknown`.
    static func map(
        from afError: AFError,
        statusCode: Int?,
        data: Data? = nil
    ) -> NetworkError {

        // 1. Try parse structured server error body
        if let data,
           let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data),
           apiError.code != nil || apiError.message != nil {
            return .apiError(apiError)
        }

        // 2. Map by HTTP status code
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 409: return .conflict
        case 422: return .unprocessableEntity
        case 429: return .tooManyRequests
        case 500: return .internalServerError
        case 503: return .serviceUnavailable
        case let code? where code >= 500: return .serverError(statusCode: code)
        default: break
        }

        // 3. Map URLError (connectivity / timeout / cancelled)
        let urlError = afError.underlyingError as? URLError
        if let urlError {
            switch urlError.code {
            case .notConnectedToInternet,
                 .networkConnectionLost,
                 .dataNotAllowed,
                 .internationalRoamingOff:
                return .noInternet
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            default:
                break
            }
        }

        // 4. Map decoding failure
        if case .responseSerializationFailed(let reason) = afError,
           case .decodingFailed(let error) = reason {
            return .decodingFailed(error)
        }

        // 5. Fallback
        return .unknown(afError)
    }
}

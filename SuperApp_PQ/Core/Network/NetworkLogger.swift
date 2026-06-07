//
//  NetworkLogger.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import Alamofire

// MARK: - NetworkLogger

/// Alamofire `EventMonitor` that pretty-prints requests and responses.
/// Active in DEBUG builds only.
final class NetworkLogger: EventMonitor {

    // MARK: - EventMonitor

    let queue = DispatchQueue(label: "com.superapp.pq.networklogger", qos: .utility)

    // MARK: - Request

    func requestDidResume(_ request: Request) {
        #if DEBUG
        let id      = request.id.uuidString.prefix(8)
        let method  = request.request?.httpMethod ?? "UNKNOWN"
        let url     = request.request?.url?.absoluteString ?? "UNKNOWN"
        let headers = request.request?.headers.dictionary ?? [:]
        let body    = request.request?.httpBody
            .flatMap { String(data: $0, encoding: .utf8) } ?? "—"

        Logger.debug("""
        ╔══════════════════════════════════════════════════════╗
        ║ 🚀 REQUEST  [\(id)]
        ║ \(method) \(url)
        ║ Headers : \(headers)
        ║ Body    : \(body)
        ╚══════════════════════════════════════════════════════╝
        """, category: .network)
        #endif
    }

    // MARK: - Response (Decodable)

    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        #if DEBUG
        let id         = request.id.uuidString.prefix(8)
        let statusCode = response.response?.statusCode ?? 0
        let url        = response.request?.url?.absoluteString ?? "UNKNOWN"
        let duration   = response.metrics
            .map { String(format: "%.0fms", $0.taskInterval.duration * 1_000) } ?? "?ms"
        let emoji      = (200..<300).contains(statusCode) ? "✅" : "❌"
        let body       = prettyBody(from: response.data)

        Logger.debug("""
        ╔══════════════════════════════════════════════════════╗
        ║ \(emoji) RESPONSE [\(id)]  \(statusCode)  (\(duration))
        ║ \(url)
        ║ Body:
        \(body.split(separator: "\n").map { "║   \($0)" }.joined(separator: "\n"))
        ╚══════════════════════════════════════════════════════╝
        """, category: .network)
        #endif
    }

    // MARK: - Error

    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        #if DEBUG
        Logger.error("Failed to create request: \(error.localizedDescription)", category: .network)
        #endif
    }

    func requestDidCancel(_ request: Request) {
        #if DEBUG
        let id = request.id.uuidString.prefix(8)
        Logger.debug("Request cancelled [\(id)]", category: .network)
        #endif
    }

    // MARK: - Private

    private func prettyBody(from data: Data?) -> String {
        guard let data, !data.isEmpty else { return "—" }

        if let json = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let string = String(data: pretty, encoding: .utf8) {
            return string
        }

        return String(data: data, encoding: .utf8) ?? "—"
    }
}

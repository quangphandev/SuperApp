//
//  BaseError.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation

enum BaseError: Error {
    case unknown
    case message(String)
    case network(Error)
    case decoding(Error)
    case unauthorized
    case noInternet

    // MARK: - Helpers

    var message: String {
        switch self {
        case .unknown:
            return "Đã có lỗi xảy ra. Vui lòng thử lại."
        case .message(let msg):
            return msg
        case .network(let error):
            return "Lỗi mạng: \(error.localizedDescription)"
        case .decoding(let error):
            return "Lỗi dữ liệu: \(error.localizedDescription)"
        case .unauthorized:
            return "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại."
        case .noInternet:
            return "Không có kết nối mạng. Vui lòng kiểm tra lại."
        }
    }
}

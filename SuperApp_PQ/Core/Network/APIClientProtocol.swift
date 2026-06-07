//
//  APIClientProtocol.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import RxSwift

// MARK: - APIClientProtocol

protocol APIClientProtocol: AnyObject {

    // ─────────────────────────────────────────
    // MARK: Standard Request
    // ─────────────────────────────────────────

    /// GET / POST / PUT / PATCH / DELETE — with a JSON response body.
    /// Decodes the response into `T: Decodable`.
    func request<T: Decodable>(_ endpoint: any APIEndpoint) -> Observable<T>

    /// GET / POST / PUT / PATCH / DELETE — without a response body (e.g. 204 No Content).
    /// Use for delete, logout, or any endpoint that returns no body.
    func requestVoid(_ endpoint: any APIEndpoint) -> Observable<Void>

    // ─────────────────────────────────────────
    // MARK: Upload
    // ─────────────────────────────────────────

    /// Multipart/form-data upload — decodes JSON response into `T`.
    func upload<T: Decodable>(
        _ endpoint: any APIEndpoint,
        data: Data,
        name: String,
        fileName: String,
        mimeType: String
    ) -> Observable<T>

    /// Multipart/form-data upload — emits `.progress(0.0...1.0)` then `.completed(T)`.
    func uploadWithProgress<T: Decodable>(
        _ endpoint: any APIEndpoint,
        data: Data,
        name: String,
        fileName: String,
        mimeType: String
    ) -> Observable<NetworkEvent<T>>

    // ─────────────────────────────────────────
    // MARK: Download
    // ─────────────────────────────────────────

    /// Downloads a file to the Documents directory.
    /// Emits the local `URL` of the saved file on completion.
    func download(_ endpoint: any APIEndpoint) -> Observable<URL>

    /// Downloads a file with progress tracking.
    /// Emits `.progress(0.0...1.0)` then `.completed(localURL)`.
    func downloadWithProgress(_ endpoint: any APIEndpoint) -> Observable<NetworkEvent<URL>>
}

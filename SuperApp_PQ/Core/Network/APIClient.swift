//
//  APIClient.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - APIClient

final class APIClient: APIClientProtocol {

    // MARK: - Properties

    private let session: Session

    // MARK: - Lifecycle

    /// - Parameters:
    ///   - interceptor: Optional `AuthInterceptor` for token injection + auto-refresh.
    ///   - logger:      Optional `NetworkLogger` for debug logging.
    init(
        interceptor: AuthInterceptor? = nil,
        logger: NetworkLogger? = nil
    ) {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest  = NetworkConfig.timeoutInterval
        configuration.timeoutIntervalForResource = NetworkConfig.timeoutInterval * 2

        var monitors: [EventMonitor] = []
        if let logger { monitors.append(logger) }

        session = Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: monitors
        )
    }

    // ─────────────────────────────────────────
    // MARK: Standard Request
    // ─────────────────────────────────────────

    func request<T: Decodable>(_ endpoint: any APIEndpoint) -> Observable<T> {
        Observable.create { [weak self] observer in
            guard let self else { observer.onCompleted(); return Disposables.create() }

            let task = self.session
                .request(
                    endpoint.url,
                    method:     endpoint.method,
                    parameters: endpoint.parameters,
                    encoding:   endpoint.encoding,
                    headers:    NetworkConfig.defaultHeaders.merging(endpoint.headers)
                )
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(NetworkError.map(from: error, statusCode: response.response?.statusCode, data: response.data))
                    }
                }

            return Disposables.create { task.cancel() }
        }
    }

    func requestVoid(_ endpoint: any APIEndpoint) -> Observable<Void> {
        Observable.create { [weak self] observer in
            guard let self else { observer.onCompleted(); return Disposables.create() }

            let task = self.session
                .request(
                    endpoint.url,
                    method:     endpoint.method,
                    parameters: endpoint.parameters,
                    encoding:   endpoint.encoding,
                    headers:    NetworkConfig.defaultHeaders.merging(endpoint.headers)
                )
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        observer.onNext(())
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(NetworkError.map(from: error, statusCode: response.response?.statusCode, data: response.data))
                    }
                }

            return Disposables.create { task.cancel() }
        }
    }

    // ─────────────────────────────────────────
    // MARK: Upload
    // ─────────────────────────────────────────

    func upload<T: Decodable>(
        _ endpoint: any APIEndpoint,
        data: Data,
        name: String,
        fileName: String,
        mimeType: String
    ) -> Observable<T> {
        Observable.create { [weak self] observer in
            guard let self else { observer.onCompleted(); return Disposables.create() }

            let task = self.session
                .upload(
                    multipartFormData: { Self.buildFormData($0, data: data, name: name, fileName: fileName, mimeType: mimeType, parameters: endpoint.parameters) },
                    to:      endpoint.url,
                    method:  endpoint.method,
                    headers: NetworkConfig.defaultHeaders.merging(endpoint.headers)
                )
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(NetworkError.map(from: error, statusCode: response.response?.statusCode, data: response.data))
                    }
                }

            return Disposables.create { task.cancel() }
        }
    }

    func uploadWithProgress<T: Decodable>(
        _ endpoint: any APIEndpoint,
        data: Data,
        name: String,
        fileName: String,
        mimeType: String
    ) -> Observable<NetworkEvent<T>> {
        Observable.create { [weak self] observer in
            guard let self else { observer.onCompleted(); return Disposables.create() }

            let task = self.session
                .upload(
                    multipartFormData: { Self.buildFormData($0, data: data, name: name, fileName: fileName, mimeType: mimeType, parameters: endpoint.parameters) },
                    to:      endpoint.url,
                    method:  endpoint.method,
                    headers: NetworkConfig.defaultHeaders.merging(endpoint.headers)
                )
                .uploadProgress { progress in
                    observer.onNext(.progress(progress.fractionCompleted))
                }
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(.completed(value))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(NetworkError.map(from: error, statusCode: response.response?.statusCode, data: response.data))
                    }
                }

            return Disposables.create { task.cancel() }
        }
    }

    // ─────────────────────────────────────────
    // MARK: Download
    // ─────────────────────────────────────────

    func download(_ endpoint: any APIEndpoint) -> Observable<URL> {
        Observable.create { [weak self] observer in
            guard let self else { observer.onCompleted(); return Disposables.create() }
            let destination = Self.defaultDestination(fileName: endpoint.url.lastPathComponent)

            let task = self.session
                .download(
                    endpoint.url,
                    headers: NetworkConfig.defaultHeaders.merging(endpoint.headers),
                    to: destination
                )
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let url):
                        if let url {
                            observer.onNext(url)
                            observer.onCompleted()
                        } else {
                            observer.onError(NetworkError.unknown(URLError(.fileDoesNotExist)))
                        }
                    case .failure(let error):
                        observer.onError(NetworkError.map(from: error, statusCode: response.response?.statusCode))
                    }
                }

            return Disposables.create { task.cancel() }
        }
    }

    func downloadWithProgress(_ endpoint: any APIEndpoint) -> Observable<NetworkEvent<URL>> {
        Observable.create { [weak self] observer in
            guard let self else { observer.onCompleted(); return Disposables.create() }
            let destination = Self.defaultDestination(fileName: endpoint.url.lastPathComponent)

            let task = self.session
                .download(
                    endpoint.url,
                    headers: NetworkConfig.defaultHeaders.merging(endpoint.headers),
                    to: destination
                )
                .downloadProgress { progress in
                    observer.onNext(.progress(progress.fractionCompleted))
                }
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let url):
                        if let url {
                            observer.onNext(.completed(url))
                            observer.onCompleted()
                        } else {
                            observer.onError(NetworkError.unknown(URLError(.fileDoesNotExist)))
                        }
                    case .failure(let error):
                        observer.onError(NetworkError.map(from: error, statusCode: response.response?.statusCode))
                    }
                }

            return Disposables.create { task.cancel() }
        }
    }

    // ─────────────────────────────────────────
    // MARK: Private Helpers
    // ─────────────────────────────────────────

    private static func buildFormData(
        _ form: MultipartFormData,
        data: Data,
        name: String,
        fileName: String,
        mimeType: String,
        parameters: Parameters?
    ) {
        form.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        parameters?.forEach { key, value in
            if let encoded = "\(value)".data(using: .utf8) {
                form.append(encoded, withName: key)
            }
        }
    }

    private nonisolated static func defaultDestination(fileName: String) -> DownloadRequest.Destination {
        { _, _ in
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL   = documents.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
    }
}

// ─────────────────────────────────────────
// MARK: - HTTPHeaders Helper
// ─────────────────────────────────────────

private extension HTTPHeaders {
    func merging(_ other: HTTPHeaders?) -> HTTPHeaders {
        guard let other else { return self }
        var result = self.dictionary
        other.dictionary.forEach { result[$0.key] = $0.value }
        return HTTPHeaders(result)
    }
}

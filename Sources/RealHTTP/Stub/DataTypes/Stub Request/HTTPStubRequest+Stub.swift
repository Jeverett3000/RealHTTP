//
//  IndomioHTTP
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Immobiliare.it SpA. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

extension HTTPStubRequest {
    
    // MARK: - Builder
    
    /// Create (and replace if exists) a new stub response for a given method and allows you
    /// to configure.
    ///
    /// - Parameters:
    ///   - method: the http method which trigger this stubbed response.
    ///   - builder: builder callback.
    /// - Returns: Self
    public func stub(for method: HTTPMethod, _ builder: ((inout HTTPStubResponse) -> Void)) -> Self {
        var response = HTTPStubResponse()
        responses[method] = response
        builder(&response)
        return self
    }
    
    // MARK: - Generic HTTP Code
    
    /// Stub a generic http status code response.
    ///
    /// - Parameters:
    ///   - method: the http method which trigger this stubbed response.
    ///   - delay: (optional) delay interval for response.
    ///   - code: status code to produce.
    /// - Returns: Self
    public func stub(for method: HTTPMethod, delay: TimeInterval? = nil, code: HTTPStatusCode) -> Self {
        stub(for: method) {
            $0.responseDelay = delay
            $0.statusCode = code
        }
    }
    
    // MARK: - Error Responses

    /// Stub a generic response error for a given method.
    ///
    /// - Parameters:
    ///   - method: the http method which trigger this stubbed response.
    ///   - delay: (optional) delay interval for response.
    ///   - error: error to trigger.
    public func stub(for method: HTTPMethod, delay: TimeInterval? = nil, error: Error) -> Self {
        stub(for: method) {
            $0.failError = error
            $0.responseDelay = delay
        }
    }
    
    // MARK: - Affermative Responses
    
    /// Stub 200 response with json data type content.
    ///
    /// - Parameters:
    ///   - method: the http method which trigger this stubbed response.
    ///   - delay: (optional) delay interval for response.
    ///   - string: json string (encoded as utf8).
    /// - Returns: Self
    public func stub(for method: HTTPMethod, delay: TimeInterval? = nil, json string: String?) -> Self {
        stub(for: method, delay: delay, contentType: .jsonUTF8, body: string)
    }
    
    /// Generic stub response with custom content type and response get from file at specified url.
    /// If file does not exist or it's not accessible no response is created.
    ///
    /// - Parameters:
    ///   - method: the http method which trigger this stubbed response.
    ///   - code: http status code.
    ///   - delay: (optional) delay interval for response.
    ///   - contentType: content type of the response.
    ///   - bodyFileURL: body of the response.
    /// - Returns: Self
    public func stub(for method: HTTPMethod, code: HTTPStatusCode = .ok, delay: TimeInterval? = nil,
                     contentType: HTTPContentType, bodyFileURL: URL) -> Self {
        guard let data = Data.fromURL(bodyFileURL) else {
            return self
        }
        
        return stub(for: method, code: code, delay: delay, contentType: contentType, body: data)
    }
    
    /// Generic stub response with custom content type.
    ///
    /// - Parameters:
    ///   - method: the http method which trigger this stubbed response.
    ///   - code: http status code.
    ///   - delay: (optional) delay interval for response.
    ///   - contentType: content type of the response.
    ///   - body: body of the response.
    /// - Returns: Self
    public func stub(for method: HTTPMethod, code: HTTPStatusCode = .ok, delay: TimeInterval? = nil,
                     contentType: HTTPContentType, body: HTTPStubDataConvertible?) -> Self {
        stub(for: method) {
            $0.contentType = contentType
            $0.statusCode = code
            $0.body = body
            $0.responseDelay = delay
        }
    }
    
}

//
//  IndomioNetwork
//
//  Created by the Mobile Team @ ImmobiliareLabs
//  Email: mobile@immobiliare.it
//  Web: http://labs.immobiliare.it
//
//  Copyright ©2021 Immobiliare.it SpA. All rights reserved.
//  Licensed under MIT License.
//

import Foundation


/// It's like `HTTPClient` but it maintain a queue of requests and
/// manage the maximum simultaneous requests you can execute
/// automatically.
/// You can use it when you need more control about the requests.
public class HTTPClientQueue: HTTPClient {
    
    // MARK: - Public Properties
    
    /// Maximum number of rimultaneous requests.
    public var maxSimultaneousRequest: Int {
        didSet {
            operationQueue.maxConcurrentOperationCount = maxSimultaneousRequest
        }
    }
    
    private var operationQueue = OperationQueue()
    
    // MARK: - Initialization
    
    public init(maxSimultaneousRequest: Int = 5,
                baseURL: String,
                configuration: URLSessionConfiguration = .default) {
        
        self.maxSimultaneousRequest = maxSimultaneousRequest
        super.init(baseURL: baseURL, configuration: configuration)
    }
    
    // MARK: - Public Functions
    
    override func execute(request: HTTPRequestProtocol) -> HTTPRequestProtocol {
        let reqOperation = HTTPRequestOperation(client: self, request: request)
        addOperation(reqOperation)
        return request
    }
    
    // MARK: - Private Functions
    
    internal func addOperation(_ operations: HTTPRequestOperation...) {
        operations.forEach {
            operationQueue.addOperation($0)
        }
    }
    
}

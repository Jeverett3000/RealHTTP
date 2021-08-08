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

/// Represent a single certificate.
open class SSLCertificate {

    // MARK: - Public Properties
    
    /// Certificate binary data.
    public internal(set) var certData: Data?
    
    /// Public key to be used.
    public internal(set) var publicKey: SecKey?
    
    // MARK: - Initialization
    
    /// Designated init for certificates, initialize a new certificate with binary data.
    ///
    /// - Parameter data: binary data of the certificate
    public init(data: Data) {
        self.certData = data
    }
    
    /// Initializer for public keys.
    ///
    /// - Parameter key: public key to be used.
    public init(publicKey: SecKey) {
        self.publicKey = publicKey
    }
    
    /// Initialize a new SSL certificate with the contents of given file URL.
    ///
    /// - Parameter fileURL: fileURL
    public convenience init?(fileURL: URL) {
        guard fileURL.isFileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        try? self.init(data: Data(contentsOf: fileURL))
    }
    
    /// Initialize from file URLs
    ///
    /// - Parameter URLs: URLs list.
    /// - Returns: [SSLCert]
    public static func fromFileURLs(_ URLs: [URL]) -> [SSLCertificate] {
        URLs.compactMap( { .init(fileURL: $0 )})
    }
    
}

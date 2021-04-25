//
//  FileManagerProtocol.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation

protocol FileManagerProtocol {
    func containerURL(forSecurityApplicationGroupIdentifier groupIdentifier: String) -> URL?
}

extension FileManager: FileManagerProtocol {}

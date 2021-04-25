//
//  RealmFactory.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation
import RealmSwift

protocol RealmFactoryProtocol {
    func makeRealm() throws -> Realm
}

final class RealmFactory: RealmFactoryProtocol {
    private let fileManager: FileManagerProtocol
    private let currentSchemaVersion: UInt64 = 1
    private let appID = "com.karinyfreitas.SimpleMarket"

    init(fileManager: FileManagerProtocol = FileManager.default) {
        self.fileManager = fileManager
    }

    private var sharedRealmConfiguration: Realm.Configuration? {
        guard let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appID) else {
            return nil
        }

        let configurationURL = containerURL.appendingPathComponent("db.realm", isDirectory: true)

        return Realm.Configuration(
            fileURL: configurationURL,
            schemaVersion: currentSchemaVersion,
            migrationBlock: { _, _ in },
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                // Realm compacting approach from https://realm.io/docs/swift/latest/#compacting-realms
                let oneHundredMB = 100 * 1024 * 1024
                return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
            }
        )
    }

    func makeRealm() throws -> Realm {
        guard let configuration = sharedRealmConfiguration else {
            throw RealmFactoryError.unableToMakeConfiguration
        }
        return try Realm(configuration: configuration)
    }
}

enum RealmFactoryError: Error {
    case unableToMakeConfiguration
}


//
//  Logger.swift
//  SimpleMarket
//
//  Created by Kariny on 25/04/21.
//

import Foundation
import os.log

struct Logger {
    private enum LogLevel: String {
        case info
        case error

        @available(iOS 10.0, *)
        var osLogType: OSLogType {
            switch self {
            case .info:
                return .info
            case .error:
                return .error
            }
        }
    }

    private func log(_ message: StaticString, level: LogLevel = .info, _ args: CVarArg...) {
        #if DEBUG
        if #available(iOS 10.0, *) {
            let appIdentifier = "SimpleMarket"
            let subsystem = Bundle.main.bundleIdentifier ?? appIdentifier
            let log = OSLog(subsystem: subsystem, category: appIdentifier)
            os_log(message, log: log, type: level.osLogType, args)
        }
        print("[\(level.rawValue.capitalized)] \(message)", args)
        #endif
    }

    func info(_ message: StaticString, _ args: CVarArg...) {
        log(message, level: .info, args)
    }

    func error(_ message: StaticString, _ args: CVarArg...) {
        log(message, level: .error, args)
    }
}

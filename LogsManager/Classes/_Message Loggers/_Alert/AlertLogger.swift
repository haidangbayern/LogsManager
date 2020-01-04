//
//  AlertLogger.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 3/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import CocoaLumberjack
import Foundation


/// Logger that logs with alerts.
open class AlertLogger: BaseAbstractTextLogger {
    
    // ******************************* MARK: - BaseAbstractTextLogger Overrides
    
    override public func process(message logMessage: DDLogMessage, formattedMessage: String) {
        g.showErrorAlert(title: logMessage.flagLogString, message: formattedMessage)
    }
}

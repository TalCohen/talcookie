//
//  Utilities.swift
//  TalCookie
//
//  Created by Tal Cohen on 10/6/16.
//  Copyright © 2016 Computer Science House. All rights reserved.
//

import Foundation

class Utilities: NSObject {
    
    // UserDefault Constants
    let deviceTokenKey = "deviceToken"
    let clientIdKey = "clientId"
    let isPairedKey = "isPaired"
    
    func getHexStringFromData(data: Data) -> String {
        /*
         Converts a device token to a hex string
         */
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        let buffer = UnsafeMutableBufferPointer<UInt8>(start: ptr, count: data.count)
        let _ = data.copyBytes(to: buffer)
        
        let hexBytes = buffer.map { (byte) -> String in
            String(format:"%02hhx", byte)
        }
        
        return hexBytes.joined(separator: "")
    }
}

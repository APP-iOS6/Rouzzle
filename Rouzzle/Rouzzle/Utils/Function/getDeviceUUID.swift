//
//  getDeviceUUID.swift
//  Rouzzle
//
//  Created by 김동경 on 11/4/24.
//

import UIKit

class Utils {

    /**
     # getDeviceUUID
     - Note: 디바이스 고유 넘버 반환
     */
    static func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}

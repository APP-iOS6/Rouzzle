//
//  SwiftDataError.swift
//  Rouzzle
//
//  Created by 김정원 on 11/8/24.
//

import Foundation

enum SwiftDataServiceError: Error {
    case invalidInput(String)
    case saveFailed(Error)
    case deleteFailed(Error)
}

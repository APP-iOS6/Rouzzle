//
//  DBError.swift
//  Rouzzle
//
//  Created by 김동경 on 11/7/24.
//

import Foundation

enum DBError: Error {
    case error(Error)
    case serializationError
    case firebaseError(Error)
    case documenetIdError
}

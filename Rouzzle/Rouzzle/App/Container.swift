//
//  DI.swift
//  Rouzzle
//
//  Created by 김동경 on 11/3/24.
//

import Foundation
import Factory

extension Container {
    // MARK: 컨테이너에서 AuthService 인스턴스를 생성하고 관리
    var authService: Factory<AuthServiceType> {
        Factory(self) { AuthService() }
    }
    
    var userService: Factory<UserServiceType> {
        Factory(self) { UserService() }
    }
    
    var routineService: Factory<RoutineServiceType> {
        Factory(self) { RoutineService() }
    }
}

//
//  TextField+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/2/24.
//

import Foundation
import UIKit
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

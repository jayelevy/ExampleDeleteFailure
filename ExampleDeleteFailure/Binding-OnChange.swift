//
//  Binding-OnChange.swift
//  CoreDataState
//
//  Created by Jay Levy on 7/21/22.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

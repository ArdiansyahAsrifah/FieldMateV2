//
//   FieldMateLiveActivityAttributes.swift
//  FieldMateV2
//
//  Created by Muhammad Ardiansyah Asrifah on 26/03/25.
//

import ActivityKit
import Foundation

struct FieldMateLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var taskTitle: String
        var taskTime: String
        var taskLocation: String
    }
    
    var taskID: String
}

//
//  AirpleAttributes.swift
//  Airple
//
//  Created by Revanza on 2024-08-09.
//

import ActivityKit
import SwiftUI

struct AirpleAttributes: ActivityAttributes {
    public typealias AirpleStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var progress: Double
        var title: String
        var status: String
        var estimated: String
        var widgetUrl: String?
    }
    
    var key: String
}
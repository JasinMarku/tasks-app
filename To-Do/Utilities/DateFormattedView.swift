//
//  DateFormattedView.swift
//  To-Do
//
//  Created by Jasin ‎ on 11/1/24.
//

import Foundation
import SwiftUI

struct DateFormattedView: View {
    var dueDate: Date
    var dueTime: Date?
    
    var body: some View {
        Text(formattedDate(dueDate, dueTime: dueTime))
    }
    
    func formattedDate(_ date: Date, dueTime: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        var result = formatter.string(from: date)
        
        if let time = dueTime {
            formatter.dateFormat = "h:mm a"
            result += " at " + formatter.string(from: time)
        }
        
        return result
    }
}

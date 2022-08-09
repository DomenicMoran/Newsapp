//
//  Date + Ext.swift
//  Newsapp
//
//  Created by Domenic Moran on 09.08.22.
//

import Foundation

extension Date {
    func getStringRepresention() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMM YYYY - HH:MM"
        
        return dateFormatter.string(from: self)
    }
}

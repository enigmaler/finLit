//
//  Transaction.swift
//  MoneyTracker
//
//  Transaction data model
//

import Foundation
import SwiftUI

struct Transaction: Identifiable, Codable, Hashable {
    var id: UUID
    var amount: Double
    var title: String
    var category: TransactionCategory
    var date: Date
    var type: TransactionType
    var notes: String
    
    init(id: UUID = UUID(), amount: Double, title: String, category: TransactionCategory, date: Date = Date(), type: TransactionType, notes: String = "") {
        self.id = id
        self.amount = amount
        self.title = title
        self.category = category
        self.date = date
        self.type = type
        self.notes = notes
    }
}

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
    
    var color: Color {
        switch self {
        case .income:
            return .green
        case .expense:
            return .red
        }
    }
    
    var icon: String {
        switch self {
        case .income:
            return "arrow.down.circle.fill"
        case .expense:
            return "arrow.up.circle.fill"
        }
    }
}

enum TransactionCategory: String, Codable, CaseIterable {
    case food = "Food"
    case transportation = "Transportation"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case bills = "Bills"
    case healthcare = "Healthcare"
    case education = "Education"
    case salary = "Salary"
    case freelance = "Freelance"
    case investment = "Investment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food:
            return "fork.knife"
        case .transportation:
            return "car.fill"
        case .shopping:
            return "bag.fill"
        case .entertainment:
            return "tv.fill"
        case .bills:
            return "doc.text.fill"
        case .healthcare:
            return "cross.case.fill"
        case .education:
            return "book.fill"
        case .salary:
            return "dollarsign.circle.fill"
        case .freelance:
            return "briefcase.fill"
        case .investment:
            return "chart.line.uptrend.xyaxis"
        case .other:
            return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food:
            return .orange
        case .transportation:
            return .blue
        case .shopping:
            return .pink
        case .entertainment:
            return .purple
        case .bills:
            return .red
        case .healthcare:
            return .green
        case .education:
            return .indigo
        case .salary:
            return .mint
        case .freelance:
            return .cyan
        case .investment:
            return .yellow
        case .other:
            return .gray
        }
    }
}

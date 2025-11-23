//
//  Formatters.swift
//  MoneyTracker
//
//  Shared formatters for currency and dates
//

import Foundation

enum FormatterKit {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        return formatter
    }()

    static func currencyString(for amount: Double) -> String {
        currency.string(from: NSNumber(value: amount)) ?? "--"
    }

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

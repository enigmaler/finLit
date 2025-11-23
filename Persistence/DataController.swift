//
//  DataController.swift
//  MoneyTracker
//
//  Data persistence using UserDefaults
//

import Foundation
import SwiftUI

class DataController: ObservableObject {
    static let shared = DataController()
    
    @Published var transactions: [Transaction] = []
    
    private let transactionsKey = "saved_transactions"
    
    private init() {
        loadTransactions()
    }
    
    func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            saveTransactions()
        }
    }
    
    var totalBalance: Double {
        transactions.reduce(0) { total, transaction in
            total + (transaction.type == .income ? transaction.amount : -transaction.amount)
        }
    }
    
    var monthlyIncome: Double {
        let calendar = Calendar.current
        let now = Date()
        return transactions
            .filter { transaction in
                transaction.type == .income &&
                calendar.isDate(transaction.date, equalTo: now, toGranularity: .month)
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    var monthlyExpense: Double {
        let calendar = Calendar.current
        let now = Date()
        return transactions
            .filter { transaction in
                transaction.type == .expense &&
                calendar.isDate(transaction.date, equalTo: now, toGranularity: .month)
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    func transactionsForCategory(_ category: TransactionCategory) -> [Transaction] {
        transactions.filter { $0.category == category }
    }
    
    func transactionsForMonth(_ date: Date) -> [Transaction] {
        let calendar = Calendar.current
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: date, toGranularity: .month)
        }
    }
}

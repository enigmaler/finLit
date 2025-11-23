//
//  TransactionRowView.swift
//  MoneyTracker
//
//  Reusable transaction row component
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(transaction.category.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: transaction.category.icon)
                    .foregroundColor(transaction.category.color)
                    .font(.system(size: 20))
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(formatDate(transaction.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(transaction.amount))
                    .font(.headline)
                    .foregroundColor(transaction.type.color)
                
                Image(systemName: transaction.type.icon)
                    .font(.caption)
                    .foregroundColor(transaction.type.color.opacity(0.6))
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    TransactionRowView(transaction: Transaction(
        amount: 50.00,
        title: "Coffee",
        category: .food,
        date: Date(),
        type: .expense
    ))
    .padding()
}

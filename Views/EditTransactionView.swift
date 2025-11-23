//
//  EditTransactionView.swift
//  MoneyTracker
//
//  Edit existing transaction view
//

import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TransactionViewModel
    
    let transaction: Transaction
    
    @State private var title: String
    @State private var amount: String
    @State private var selectedType: TransactionType
    @State private var selectedCategory: TransactionCategory
    @State private var date: Date
    @State private var notes: String
    
    init(transaction: Transaction) {
        self.transaction = transaction
        _title = State(initialValue: transaction.title)
        _amount = State(initialValue: String(format: "%.2f", transaction.amount))
        _selectedType = State(initialValue: transaction.type)
        _selectedCategory = State(initialValue: transaction.category)
        _date = State(initialValue: transaction.date)
        _notes = State(initialValue: transaction.notes)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Transaction Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Details") {
                    TextField("Title", text: $title)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(availableCategories, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    Button(role: .destructive) {
                        deleteTransaction()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Transaction")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var availableCategories: [TransactionCategory] {
        switch selectedType {
        case .income:
            return [.salary, .freelance, .investment, .other]
        case .expense:
            return [.food, .transportation, .shopping, .entertainment, .bills, .healthcare, .education, .other]
        }
    }
    
    private var isValid: Bool {
        !title.isEmpty && !amount.isEmpty && Double(amount) != nil && Double(amount)! > 0
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else { return }
        
        var updatedTransaction = transaction
        updatedTransaction.title = title
        updatedTransaction.amount = amountValue
        updatedTransaction.type = selectedType
        updatedTransaction.category = selectedCategory
        updatedTransaction.date = date
        updatedTransaction.notes = notes
        
        viewModel.updateTransaction(updatedTransaction)
        dismiss()
    }
    
    private func deleteTransaction() {
        viewModel.deleteTransaction(transaction)
        dismiss()
    }
}

#Preview {
    EditTransactionView(transaction: Transaction(
        amount: 50.00,
        title: "Coffee",
        category: .food,
        date: Date(),
        type: .expense
    ))
    .environmentObject(TransactionViewModel())
}

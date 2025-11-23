//
//  AddTransactionView.swift
//  MoneyTracker
//
//  Add new transaction view
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TransactionViewModel
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: TransactionCategory = .food
    @State private var date: Date = Date()
    @State private var notes: String = ""
    
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
            }
            .navigationTitle("New Transaction")
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
        
        let transaction = Transaction(
            amount: amountValue,
            title: title,
            category: selectedCategory,
            date: date,
            type: selectedType,
            notes: notes
        )
        
        viewModel.addTransaction(transaction)
        dismiss()
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(TransactionViewModel())
}

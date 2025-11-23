//
//  StatisticsView.swift
//  MoneyTracker
//
//  Statistics and charts view
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Summary Cards
                    SummaryCardsView()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Category Breakdown
                    CategoryBreakdownView()
                        .padding(.horizontal)
                    
                    // Monthly Trend
                    MonthlyTrendView()
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Statistics")
        }
    }
}

struct SummaryCardsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                SummaryCard(
                    title: "Total Balance",
                    amount: viewModel.totalBalance,
                    color: viewModel.totalBalance >= 0 ? .green : .red,
                    icon: "dollarsign.circle.fill"
                )
                
                SummaryCard(
                    title: "This Month",
                    amount: viewModel.monthlyIncome - viewModel.monthlyExpense,
                    color: (viewModel.monthlyIncome - viewModel.monthlyExpense) >= 0 ? .green : .red,
                    icon: "calendar"
                )
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(formatCurrency(amount))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct CategoryBreakdownView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expense by Category")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.categoryExpenses.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No expense data yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                )
                .padding(.horizontal)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.categoryExpenses, id: \.category) { item in
                        CategoryRowView(category: item.category, amount: item.amount, total: totalExpenses)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var totalExpenses: Double {
        viewModel.categoryExpenses.reduce(0) { $0 + $1.amount }
    }
}

struct CategoryRowView: View {
    let category: TransactionCategory
    let amount: Double
    let total: Double
    
    private var percentage: Double {
        total > 0 ? (amount / total) * 100 : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(category.color.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: category.icon)
                            .foregroundColor(category.color)
                            .font(.system(size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.rawValue)
                            .font(.headline)
                        
                        Text(String(format: "%.1f%%", percentage))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text(formatCurrency(amount))
                    .font(.headline)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(category.color)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct MonthlyTrendView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var monthlyData: [(month: String, income: Double, expense: Double)] {
        let calendar = Calendar.current
        let now = Date()
        var data: [(month: String, income: Double, expense: Double)] = []
        
        for i in 0..<6 {
            if let date = calendar.date(byAdding: .month, value: -i, to: now) {
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MMM"
                let monthName = monthFormatter.string(from: date)
                
                let transactions = viewModel.transactions.filter { transaction in
                    calendar.isDate(transaction.date, equalTo: date, toGranularity: .month)
                }
                
                let income = transactions
                    .filter { $0.type == .income }
                    .reduce(0) { $0 + $1.amount }
                
                let expense = transactions
                    .filter { $0.type == .expense }
                    .reduce(0) { $0 + $1.amount }
                
                data.append((month: monthName, income: income, expense: expense))
            }
        }
        
        return data.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Trend")
                .font(.headline)
                .padding(.horizontal)
            
            if monthlyData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No trend data yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                )
                .padding(.horizontal)
            } else {
                VStack(spacing: 16) {
                    ForEach(monthlyData, id: \.month) { data in
                        MonthlyRowView(month: data.month, income: data.income, expense: data.expense)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MonthlyRowView: View {
    let month: String
    let income: Double
    let expense: Double
    
    private var net: Double {
        income - expense
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(month)
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Income")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatCurrency(income))
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expense")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatCurrency(expense))
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Net")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatCurrency(net))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(net >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

#Preview {
    StatisticsView()
        .environmentObject(TransactionViewModel())
}

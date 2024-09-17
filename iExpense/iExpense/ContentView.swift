//
//  ContentView.swift
//  iExpense
//
//  Created by Joe May on 13/05/2024.
//

import SwiftUI
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet{
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}
struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var totalAmount = 0.0
    var body: some View {
        NavigationStack{
            HStack{
                List{
                    Section(header: Text("Business Expenses")){
                    ForEach(expenses.items) { item in
                        if (item.type == "Business"){
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text(item.type)
                                }
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: "EUR"))
                                
                            }
                            
                        }
                    }
                    .onDelete(perform: removeItems)
                                         }
                }
                List{
                    Section(header: Text("Personal Expenses")){
                        ForEach(expenses.items) { item in
                            if (item.type == "Personal"){
                                HStack{
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        
                                        Text(item.type)
                                    }
                                    Spacer()
                                    
                                    Text(item.amount, format: .currency(code: "EUR"))
                                }
                                
                            }
                        }
                        
                        .onDelete(perform: removeItems)
                    }
                }
            }
            
            .navigationTitle("iExpense")
            .toolbar{
                Button("Add Expense", systemImage: "plus"){
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses, total: totalAmount)
            }
            Text("Total Expenses: \(totalAmount)")
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
    func removeItems(at offset: IndexSet){
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  ActivityTracker
//
//  Created by Joe May on 14/06/2024.
//

import SwiftUI


struct Activity: Identifiable{
    var name: String
    var description: String
    var id: UUID = UUID()
}
@Observable
class Activities{
    var activities: [Activity] = []
    

}

struct AddActivityView: View {
    @Binding var activities = Activities()
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
struct ContentView: View {
    @State private var activities =  Activities()
    @State private var showingAddActivity = false
    var body: some View {
        NavigationStack{
                List {
                    ForEach(activities.activities) { activity in
                        VStack(alignment: .leading) {
                            Text(activity.name)
                                .font(.headline)
                            Text(activity.description)
                                .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("Activities")
                .onAppear {
                    // Optionally add some initial activities
                    activities.activities.append(Activity(name: "Running", description: "A nice run in the park."))
                    activities.activities.append(Activity(name: "Swimming", description: "Swimming in the pool."))
                }
                Button("Add Activity"){
                    showingAddActivity = true
                }
                .sheet(isPresented: $showingAddActivity){
                    AddActivityView(activities: $activities)
                }

        }
        }
    }

#Preview {
    ContentView()
}

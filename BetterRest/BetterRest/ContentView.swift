//
//  ContentView.swift
//  BetterRest
//
//  Created by Joe May on 27/12/2023.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
   static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    var recommendedBedtime: String {
            do {
                let config = MLModelConfiguration()
                let model = try SleepCalculator(configuration: config)
                let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
                let hour = (components.hour ?? 0) * 60 * 60
                let minutes = (components.minute ?? 0) * 60
                let prediction = try model.prediction(wake: Int64(hour + minutes), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
                let sleepTime = wakeUp - prediction.actualSleep

                return "Your ideal bedtime is\n\(sleepTime.formatted(date: .omitted, time: .shortened))"
            } catch {
                return "Error calculating bedtime"
            }
        }
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing:0){
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing:0){
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing:0){
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker("",selection: $coffeeAmount){
                        
                        ForEach(1..<21){numbers in
                            Text("^[\(numbers) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                Text(recommendedBedtime)
                    .font(.system(size: 24, weight: .bold))
                                           .multilineTextAlignment(.center)
                                           .padding()
            }
            .navigationTitle("BetterRest")
            
            }
            
        }

    }
  /*  func calculateBedtime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minutes = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Int64(hour + minutes), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch{
            alertTitle = "Error"
            alertMessage = "Sorry, There was a problem computing your bedtime "
        }
        showingAlert = true
    }
   */



#Preview {
    ContentView()
}

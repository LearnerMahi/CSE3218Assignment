//
//  ContentView.swift
//  Mahi2007054
//
//  Created by Gaming Lab on 7/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var weight: String = ""
    @State private var feet: String = ""
    @State private var inches: String = ""
    @State private var bmiResult: String = ""
    @State private var bmiCategory: String = ""
    @State private var weightChangeMessage: String = ""
    @State private var selectedWeightUnit = "kg"
    
    @State private var bmiSymbol: String = "heart.fill"
    @State private var showInvalidHeightMessage: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Text("BMI Calculator")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 25) {
                 
                    HStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                        
                        TextField("Enter Weight", text: $weight)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .font(.title2)
                            .frame(width: 150)
                        
                        Picker("Unit", selection: $selectedWeightUnit) {
                            Text("kg").tag("kg")
                            Text("lb").tag("lb")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                    }

                
                    HStack {
                        Image(systemName: "ruler")
                            .font(.system(size: 25))
                            .foregroundColor(.white)

                        TextField("Feet", text: $feet)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .frame(width: 80)
                            .font(.title2)

                        TextField("Inches", text: $inches)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .frame(width: 80)
                            .font(.title2)
                    }

                    
                    if showInvalidHeightMessage {
                        Text("You can't be that tall")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding(.top)
                    }

              
                    Button(action: calculateBMI) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Calculate BMI")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }

                   
                    Text(bmiResult)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top)

                    Text(bmiCategory)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top)

                    Text(weightChangeMessage)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.top)

                    
                    Image(systemName: bmiSymbol)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .padding(.top)

                   
                    Button(action: resetValues) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Restart")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                    .padding(.top)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
            }
        }
    }

    func calculateBMI() {
       
        guard let feetValue = Double(feet), let inchesValue = Double(inches) else {
            return
        }

        
        if feetValue < 1 || feetValue > 8 || inchesValue < 0 || inchesValue > 11 {
            showInvalidHeightMessage = true
            bmiResult = ""
            bmiCategory = ""
            weightChangeMessage = ""
            bmiSymbol = "heart.fill"
            return
        } else {
            showInvalidHeightMessage = false
        }

        guard let weightValue = Double(weight) else { return }
        
        let heightInMeters = (feetValue * 0.3048) + (inchesValue * 0.0254)
        let heightSquared = heightInMeters * heightInMeters
        
        var weightInKg = weightValue
        if selectedWeightUnit == "lb" {
            weightInKg = weightValue * 0.453592
        }
        
        let bmi = weightInKg / heightSquared
        bmiResult = String(format: "Your BMI: %.2f", bmi)
        
        if bmi < 18.5 {
            bmiCategory = "Underweight"
            bmiSymbol = "heart.fill"
            calculateWeightGain(bmi: bmi, heightInMeters: heightInMeters)
        } else if bmi >= 18.5 && bmi < 24.9 {
            bmiCategory = "Normal weight"
            bmiSymbol = "heart.circle.fill"
            weightChangeMessage = "You are in a healthy weight range!"
        } else if bmi >= 25 && bmi < 29.9 {
            bmiCategory = "Overweight"
            bmiSymbol = "exclamationmark.triangle.fill"
            weightChangeMessage = "Consider losing weight to achieve a healthy BMI."
        } else {
            bmiCategory = "Obese"
            bmiSymbol = "xmark.octagon.fill"
            calculateWeightLoss(bmi: bmi, heightInMeters: heightInMeters)
        }
    }

    func resetValues() {
        weight = ""
        feet = ""
        inches = ""
        bmiResult = ""
        bmiCategory = ""
        weightChangeMessage = ""
        bmiSymbol = "heart.fill"
        showInvalidHeightMessage = false
    }

    func calculateWeightGain(bmi: Double, heightInMeters: Double) {
       
        let minBMI = 18.5
        let maxBMI = 24.9
        
        let minWeight = minBMI * heightInMeters * heightInMeters
        let maxWeight = maxBMI * heightInMeters * heightInMeters
        
        let minWeightGain = minWeight - (bmi * heightInMeters * heightInMeters)
        let maxWeightGain = maxWeight - (bmi * heightInMeters * heightInMeters)
        
        weightChangeMessage = "Gain between \(String(format: "%.2f", minWeightGain)) kg and \(String(format: "%.2f", maxWeightGain)) kg to reach a normal BMI."
    }

    func calculateWeightLoss(bmi: Double, heightInMeters: Double) {
        
        let maxBMI = 24.9
        
        let maxWeight = maxBMI * heightInMeters * heightInMeters
        let weightLoss = bmi * heightInMeters * heightInMeters - maxWeight
        
        weightChangeMessage = "Lose up to \(String(format: "%.2f", weightLoss)) kg to reach a healthy BMI."
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

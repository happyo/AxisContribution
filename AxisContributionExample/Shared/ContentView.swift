//
//  ContentView.swift
//  AxisContributionExample
//
//  Created by jasu on 2022/02/23.
//  Copyright (c) 2022 jasu All rights reserved.
//

import SwiftUI
import AxisContribution

struct ContentView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var constant: ACConstant = .init(axisMode: .horizontal, levelLabel: .number, customLessLabel: "sad", customMoreLabel: "happy", customLessLabelColor: Color.red, customMoreLabelColor: Color.red, customLevelMap: [0: 0, 1: 0.5, 2: 1])
    @State private var rowSize: CGFloat = 11
    @State private var rowImageName: String = ""
    @State private var dataSet: [Date: ACData] = [:]
    
    var body: some View {
        VStack {
            Spacer()
            // AxisContribution(constant: constant, source: getDates())
            AxisContribution(constant: constant, source: dataSet) { indexSet, data in
                if rowImageName.isEmpty {
                    defaultBackground
                }else {
                    background
                }
            } foreground: { indexSet, data in
                if rowImageName.isEmpty {
                    defaultForeground
                }else {
                    foreground
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .fill(Color.gray)
                    .opacity(0.5)
            )
            .frame(maxWidth: 600, maxHeight: 600)
            
            Spacer()
            Picker("", selection: $rowImageName) {
                Text("Default").tag("")
                Image(systemName: "heart.fill").tag("heart.fill")
                Image(systemName: "umbrella.fill").tag("umbrella.fill")
                Image(systemName: "flame.fill").tag("flame.fill")
                Image(systemName: "seal.fill").tag("seal.fill")
            }
            .pickerStyle(.segmented)
            HStack {
                Text("Row Size : ")
                Slider(value: $rowSize, in: 11...40)
                Text("\(rowSize, specifier: "%.2f")")
            }
            Picker("", selection: $constant.axisMode) {
                Text("Horizontal").tag(ACAxisMode.horizontal)
                Text("Vertical").tag(ACAxisMode.vertical)
            }
            .pickerStyle(.segmented)
            Button("Refresh Dates") {
                dataSet = getDates()
            }
            .padding()
        }
        .padding()
        .onAppear {
            dataSet = getDates()
        }
    }
    
    private var defaultBackground: some View {
        Rectangle()
            .fill(Color(hex: colorScheme == .dark ? 0x171B21 : 0xF0F0F0))
            .frame(width: rowSize, height: rowSize)
            .cornerRadius(2)
    }
    
    private var defaultForeground: some View {
        Rectangle()
            .fill(Color(hex: 0x6CD164))
            .frame(width: rowSize, height: rowSize)
            .border(Color.white.opacity(0.2), width: 1)
            .cornerRadius(2)
    }
    
    private var background: some View {
        Image(systemName: rowImageName)
            .foregroundColor(Color(hex: colorScheme == .dark ? 0x171B21 : 0xF0F0F0))
            .font(.system(size: rowSize))
            .frame(width: rowSize, height: rowSize)
    }
    
    private var foreground: some View {
        Image(systemName: rowImageName)
            .foregroundColor(Color(hex: 0x6CD164))
            .font(.system(size: rowSize))
            .frame(width: rowSize, height: rowSize)
    }
    
    private func getDates() -> [Date: ACData] {
        var sequenceDatas = [Date: ACData]()
        for _ in 0..<300 {
            let date = Date.randomBetween(start: Date().dateHalfAyear, end: Date())
            sequenceDatas[date.startOfDay] = .init(date: date.startOfDay, count: Int.random(in: 0...10))
        }
        return sequenceDatas
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}

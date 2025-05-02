//
//  PerformanceChart.swift
//  TableViewExample
//
//  Created by Lucy Chetalam on 29/04/2025.
//  Copyright © 2025 CodeWithCal. All rights reserved.
//

import Foundation
import SwiftUI
import Charts


struct PerformanceChart: View {
    
    let sparkline: [String?]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart {
                // Iterating over the sparkline data, ensuring to handle nil values
                ForEach(0..<sparkline.count, id: \.self) { index in
                    if let valueString = sparkline[index], let value = Double(valueString) {
                        // Plotting the data points
                        LineMark(
                            x: .value("Index", index),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        PointMark(
                            x: .value("Index", index),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(.white)
                        .symbolSize(3)
                    }
                }
            }.chartYAxis{
                AxisMarks(position: .leading)
            }
            .chartXAxisLabel("Occurance", alignment: .center)
            .chartYAxisLabel("Performance")
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 16.0, *) {
            Chart {
                // Iterating over the sparkline data, ensuring to handle nil values
                ForEach(0..<sparkline.count, id: \.self) { index in
                    if let valueString = sparkline[index], let value = Double(valueString) {
                        // Plotting the data points
                        BarMark(
                            x: .value("Index", index),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        
                        PointMark(
                            x: .value("Index", index),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(.white)
                        .symbolSize(3)
                    }
                }
            }.chartYAxis{
                AxisMarks(position: .leading)
            }
            .chartXAxisLabel("Occurance", alignment: .center)
            .chartYAxisLabel("Performance")
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
}


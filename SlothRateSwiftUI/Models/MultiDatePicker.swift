//
//  MultiDatePicker.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 13.12.2021.
//

import SwiftUI

struct MultiDatePicker: View {
    
    enum PickerType {
        case singleDay
        case anyDays
        case dateRange
    }
    
    @StateObject var monthModel: MDPModel
        
    // selects only a single date
    
    init(singleDay: Binding<Date>

//         includeDays: DateSelectionChoices = .allDays,
//         minDate: Date? = nil,
//         maxDate: Date? = nil
    ) {
//        _monthModel = StateObject(wrappedValue: MDPModel(singleDay: singleDay, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
        
        _monthModel = StateObject(wrappedValue: MDPModel(singleDay: singleDay))
    }
    
    // selects any number of dates, non-contiguous
    
    init(anyDays: Binding<[Date]>
//         includeDays: DateSelectionChoices = .allDays,
//         minDate: Date? = nil,
//         maxDate: Date? = nil
    ) {
//        _monthModel = StateObject(wrappedValue: MDPModel(anyDays: anyDays, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
        _monthModel = StateObject(wrappedValue: MDPModel(anyDays: anyDays))
    }
    
    // selects a closed date range
    
    init(dateRange: Binding<ClosedRange<Date>?>,
//         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
//        _monthModel = StateObject(wrappedValue: MDPModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
        _monthModel = StateObject(wrappedValue: MDPModel(dateRange: dateRange, minDate: minDate, maxDate: maxDate))
    }
    
    var body: some View {
        MDPMonthView()
            .environmentObject(monthModel)
    }
}

struct MultiDatePicker_Previews: PreviewProvider {
    @State static var oneDay = Date()
    @State static var manyDates = [Date]()
    @State static var dateRange: ClosedRange<Date>? = nil
    
    static var previews: some View {
        ScrollView {
            VStack {
                MultiDatePicker(singleDay: $oneDay)
                MultiDatePicker(anyDays: $manyDates)
                MultiDatePicker(dateRange: $dateRange)
            }
        }
    }
}

//
//  ComparisonView.swift
//  SlothRateSwiftUI
//
//  Created by Polina Portova on 13.12.2021.
//

import SwiftUI

struct ComparisonView: View {

   
    
    @State var setOfDays = [Date]()
    @State var rangeOfDates: ClosedRange<Date>? = nil

    
    
    var body: some View {

//        let arrayOfDates = convertDates(dates: setOfDays)
        Text("\(setOfDays[0])" as String)
//        Text("\(rangeOfDates)")
    }
     
    
    func convertDates(dates: [Date]) -> [String] {
        let formatter = Formatter()
        var arrayOfStrings = [String]()
        for date in dates {
            guard let item = formatter.string(for: date) else { return [""] }
            arrayOfStrings.append(item)
        }
       return arrayOfStrings
    }
}


struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView()
    }
}

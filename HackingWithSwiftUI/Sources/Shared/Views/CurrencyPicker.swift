//
//  CurrencyPicker.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 05.08.2023.
//

import SwiftUI

public struct CurrencyPicker: View, Equatable {
    private let currencyArr: [String] = Locale.commonISOCurrencyCodes
    
    let title: String
    @Binding var currency: String
    
    public var body: some View {
        Picker(
            title,
            selection: $currency
        ) {
            ForEach(currencyArr, id: \.self) { currency in
                Text(currency)
                    .tag(currency)
            }
        }
    }
    
    public init(
        title: String,
        currency: Binding<String>
    ) {
        self.title = title
        self._currency = currency
    }
    
    public static func == (lhs: CurrencyPicker, rhs: CurrencyPicker) -> Bool {
        return lhs.title == rhs.title &&
        lhs._currency.wrappedValue == rhs._currency.wrappedValue
    }
}

#Preview {
    CurrencyPicker(
        title: "title",
        currency: .constant("USD")
    )
}

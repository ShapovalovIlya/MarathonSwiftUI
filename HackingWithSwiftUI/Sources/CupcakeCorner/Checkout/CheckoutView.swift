//
//  CheckoutView.swift
//  
//
//  Created by Илья Шаповалов on 22.08.2023.
//

import SwiftUI

struct CheckoutView: View {
    private let imageURL: URL? = .init(string: "https://hws.dev/img/cupcakes@3x.jpg")
    
    let cost: Double
    let placeOrderButtonTap: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(
                    url: imageURL,
                    content: configure(image:),
                    placeholder: ProgressView.init
                )
                .frame(height: 233)
                
                Text("Your total is \(cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order", action: placeOrderButtonTap)
                    .padding()
            }
        }
    }
    
    private func configure(image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    CheckoutView(cost: 1, placeOrderButtonTap: { })
}

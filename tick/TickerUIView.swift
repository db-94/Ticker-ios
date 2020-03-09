//
//  TickerUIView.swift
//  tick
//
//  Created by Martin Calvert on 3/5/20.
//  Copyright © 2020 Martin Calvert. All rights reserved.
//

import SwiftUI

struct TickerUIView: View {
    @Binding var ticker: Ticker
    @Binding var dismiss: Bool
    @Binding var saveTicker: Bool

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(titleText()).font(.title)
            HStack {
                Text("Name")
                Divider()
                TextField("Name", text: $ticker.name).padding(.leading, 10.0)
            }
            Divider()
            DatePicker(selection: $ticker.date, displayedComponents: .date) {
                Text("Date")
            }
            Divider()
            DatePicker(selection: $ticker.date, displayedComponents: .hourAndMinute) {
                Text("Time")
            }
            Divider()
            Spacer()
            Button(action: {
                self.saveTicker = true
                self.dismiss.toggle()
            }, label: {
                Text("Save").font(.largeTitle)
                .frame(width: 77, height: 70)
                    .foregroundColor(Color(Constants.pink.rawValue))
            })
        }.padding(.leading, 4.0)
    }

    func titleText() -> String {
        if ticker.name.isEmpty {
            return "Add Ticker"
        } else {
            return ticker.name
        }
    }
}

struct TickerUIView_Previews: PreviewProvider {
    static var previews: some View {
        TickerUIView(ticker: .constant(Ticker.defaultTicker()), dismiss: .constant(true), saveTicker: .constant(true))
    }
}

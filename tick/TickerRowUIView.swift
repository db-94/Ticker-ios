//
//  TickerRowUIView.swift
//  tick
//
//  Created by Martin Calvert on 2/25/20.
//  Copyright © 2020 Martin Calvert. All rights reserved.
//

import SwiftUI

struct TickerRowUIView: View {
    let ticker: Ticker
    @Binding var needRefresh: Bool

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(ticker.name)
                    .font(.title)
            }
            HStack(alignment: .center) {
                Text(ticker.timeTill).padding(.leading, 10.0).accentColor(self.needRefresh ? .white : .black)
                Spacer()
                Text(ticker.dateTimeString).padding(.trailing, 10.0)
            }
        }
    }
}

struct TickerRowUIView_Previews: PreviewProvider {
    static var previews: some View {
        TickerRowUIView(ticker: Ticker(date: Date().addingTimeInterval(TimeInterval(1000)), name: "Martin"), needRefresh: .constant(true))
    }
}

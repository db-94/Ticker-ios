//
//  TickersUIView.swift
//  tick
//
//  Created by Martin Calvert on 2/25/20.
//  Copyright © 2020 Martin Calvert. All rights reserved.
//

import SwiftUI

struct TickersUIView: View {
    @ObservedObject var tickerFetcher = TickerFetcher()
    @State private var showTicker: Bool = false
    @State private var tempTicker: Ticker = Ticker.defaultTicker()
    @State private var saveTicker: Bool = false

    var body: some View {
        VStack {
            Image("header").resizable().frame(width: CGFloat(200.0), height: CGFloat(70.0), alignment: .bottom).padding(.all, -15.0)
            ZStack {
                List(tickerFetcher.tickers, id: \Ticker.id) { ticker in
                    TickerRowUIView(ticker: ticker).onTapGesture {
                        self.tempTicker = ticker
                        self.showTicker.toggle()
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showTicker.toggle()
                            self.tempTicker = Ticker.defaultTicker()
                        }, label: {
                            Text("+").font(.system(.largeTitle))
                            .frame(width: 77, height: 70)
                            .foregroundColor(Color.black)
                            .padding(.bottom, 7)
                        })
                    .background(Color(Constants.teal.rawValue))
                            .cornerRadius(38.5).padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                            .sheet(isPresented: $showTicker, onDismiss: {
                                if self.saveTicker {
                                    if let update = self.tickerFetcher.tickers.firstIndex(where: { item in
                                        return item.id == self.tempTicker.id
                                    }) {
                                        self.tickerFetcher.tickers[update] = self.tempTicker
                                    } else {
                                        self.tickerFetcher.tickers.append(self.tempTicker)
                                    }
                                    self.tempTicker = Ticker.defaultTicker()
                                    self.saveTicker = false
                                    self.save(tickers: self.tickerFetcher.tickers)
                                }
                            }) { TickerUIView(ticker: self.$tempTicker, dismiss: self.$showTicker, saveTicker: self.$saveTicker) }
                    }
                }
            }
        }
    }

    func save(tickers: [Ticker]) {
        let jsonData = try? JSONEncoder().encode(tickers)
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("user.json") {
            do {
                try jsonData?.write(to: url)
            } catch let error {
                print(error)
            }
        }
        print("after url")
    }
}

struct TickersUIView_Previews: PreviewProvider {
    static var previews: some View {
        TickersUIView()
    }
}

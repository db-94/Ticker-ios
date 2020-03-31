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
    @State var needRefresh: Bool = false
    @State var timer = Timer.publish(every: 60.0, on: .main, in: .common).autoconnect()
    @State var intervalSeconds = 20.0

    func setupNotifications() {
        //Scheduling the Notification
        let center = UNUserNotificationCenter.current()

        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        for ticker in self.tickerFetcher.tickers {
            let content = UNMutableNotificationContent()
            content.title = ticker.name
            content.body = "It is time!"
            content.sound = UNNotificationSound.default

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: ticker.date)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            let request = UNNotificationRequest(identifier: "REMINDER", content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func onDelete(offsets: IndexSet) {
        tickerFetcher.tickers.remove(atOffsets: offsets)
        save(tickers: tickerFetcher.tickers)
    }

    var body: some View {
        VStack {
            Image("header").resizable().frame(width: CGFloat(200.0), height: CGFloat(70.0), alignment: .bottom).padding(.all, -15.0)
            Divider()
            ZStack {
                List {
                    ForEach(tickerFetcher.tickers, id: \Ticker.id) { ticker in
                        TickerRowUIView(ticker: ticker, needRefresh: self.$needRefresh).onTapGesture {
                            self.tempTicker = ticker
                            self.showTicker.toggle()
                        }
                    }.onDelete(perform: onDelete).onReceive(timer) { _ in
                        self.needRefresh.toggle()
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
            }.onReceive(self.tickerFetcher.objectWillChange) {
                self.setupNotifications()
                self.setupTimer()
            }.onAppear {
                self.setupTimer()
                self.setupNotifications()
            }
        }
    }

    // MARK: - Helper Functions

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
    }

    func setupTimer() {
        for ticker in self.tickerFetcher.tickers {
            if (ticker.date.seconds(from: Date()) < 60 && ticker.date.seconds(from: Date()) > -60) {
                self.intervalSeconds = 1.0
                break
            } else {
                self.intervalSeconds = 30.0
            }
        }

        timer = Timer.publish(every: self.intervalSeconds, on: .main, in: .common).autoconnect()
    }
}

struct TickersUIView_Previews: PreviewProvider {
    static var previews: some View {
        TickersUIView()
    }
}

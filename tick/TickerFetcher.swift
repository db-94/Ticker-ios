//
//  TickerFetcher.swift
//  tick
//
//  Created by Martin Calvert on 3/8/20.
//  Copyright © 2020 Martin Calvert. All rights reserved.
//

import Foundation

public class TickerFetcher: ObservableObject {
    @Published var tickers = [Ticker]()

    init() {
        loadTickers()
    }

    func loadTickers() {
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("user.json") {
            if let jsonData = try? Data(contentsOf: url) {
                if let arr = try? JSONDecoder().decode(Array<Ticker>.self, from: jsonData) {
                    self.tickers = arr
                }
            }
        }
    }

}

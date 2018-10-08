//
//  constants.swift
//  tick
//
//  Created by Martin Calvert on 9/13/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import Foundation

enum Constants: String {
    case black = "BlackColor"
    case white = "WhiteColor"
    case teal = "TealColor"
    case purple = "PurpleColor"
    case pink = "PinkColor"

    static let whiteText: [String] = [Constants.black.rawValue, Constants.purple.rawValue, Constants.pink.rawValue]
    static let blackText: [String] = [Constants.teal.rawValue, Constants.white.rawValue]
}

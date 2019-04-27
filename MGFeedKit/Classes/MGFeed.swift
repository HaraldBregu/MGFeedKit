// 
//  MGFeed.swift
//
//  Created by harald bregu on 31/03/2019.
//  Copyright © 2019 Dream Building Company. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public protocol MGFeedAsset {
    var string: MGFeedString { get set }
    var font: MGFeedFont { get set }
    var image: MGFeedImage { get set }
    var color: MGFeedColor { get set }
    var data: MGFeedData { get set }
}

public protocol MGFeedString {
    var title: String { get set }
    var navigationTitle: String { get set }
    var searchBarPlaceholder: String { get set }
}

public protocol MGFeedFont {
    var navigationTitle: UIFont? { get set }
    var cellTitle: UIFont? { get set }
    var cellDate: UIFont? { get set }
    var cellDescription: UIFont? { get set }
}

public protocol MGFeedImage {
    var navigationItemMenu: UIImage { get set }
    var navigationItemShare: UIImage { get set }
}

public protocol MGFeedColor {
    var navigationBar: UIColor { get set }
    var navigationBarTint: UIColor { get set }
    var toolBar: UIColor { get set }
    var toolBarTint: UIColor { get set }
    var backgroundView: UIColor { get set }
    var backgroundTableView: UIColor { get set }
    var tableViewSeparator: UIColor { get set }
    var refreshTint: UIColor { get set }
    var searchBarTint: UIColor { get set }
    var backgroundViewCell: UIColor { get set }
    var cellTint: UIColor { get set }
}

public protocol MGFeedData {
    var url: String { get set }
    var enableAds: Bool { get set }
    var adsUnitId: String { get set }
    var darkKeyboard: Bool { get set }
}

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
    var tableViewCellTitle: UIFont? { get set }
    var tableViewCellSubtitle: UIFont? { get set }
    var tableViewCellDescription: UIFont? { get set }
    var detailViewTitle: UIFont? { get set }
    var detailViewSubtitle: UIFont? { get set }
    var detailViewDescription: UIFont? { get set }
}

public protocol MGFeedImage {

}

public protocol MGFeedColor {
    var navigationBar: UIColor { get set }
    var navigationBarContent: UIColor { get set }
    var refreshControl: UIColor { get set }
    var searchBar: UIColor { get set }
    var searchBarContent: UIColor { get set }
    var toolBar: UIColor { get set }
    var toolBarContent: UIColor { get set }
    var view: UIColor { get set }
    var viewContent: UIColor { get set }
    var tableView: UIColor { get set }
    var tableViewContent: UIColor { get set }
    var tableViewSeparator: UIColor { get set }
    var tableViewCell: UIColor { get set }
    var tableViewCellContent: UIColor { get set }
    var collectionView: UIColor { get set }
    var collectionViewContent: UIColor { get set }
    var tableViewCellTitle: UIColor { get set }
    var tableViewCellSubtitle: UIColor { get set }
    var tableViewCellDescription: UIColor { get set }
}

public protocol MGFeedData {
    var url: String { get set }
    var enableAds: Bool { get set }
    var adsUnitId: String { get set }
    var keyboardAppearance: UIKeyboardAppearance { get set }
    var activityIndicatorStyle: UIActivityIndicatorView.Style { get set }
}

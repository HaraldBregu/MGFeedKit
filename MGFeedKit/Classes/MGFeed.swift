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


public class MGFeed {
    public var url:String!
    public init() {
    }
}

public class MGAsset {
    public var image:MGImage!
    public var font:MGFont!
    public var color:MGColor!
    public var string:MGString!
    public init() {
        
    }
}

public class MGImage {
    public var navigationItemMenu:UIImage = UIImage()
    public init() {
        
    }
}

public class MGFont {
    public init() {
        
    }
}

public class MGColor {
    public var backgroundView:UIColor!
    public var backgroundTableView:UIColor!
    public var tableViewSeparator:UIColor!
    public var refreshTint:UIColor!
    public var navigationBar:UIColor!
    public var navigationBarTint:UIColor!
    public var toolBar:UIColor!
    public var toolBarTint:UIColor!
    public var searchBarTint:UIColor!
    public var backgroundViewCell:UIColor!
    public var cellTint:UIColor!
    public init() {
        
    }
}

public class MGString {
    public var title:String!
    public var navigationTitle:String!
    public var searchBarPlaceholder:String!
    public init() {
        
    }
}

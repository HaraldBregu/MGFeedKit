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
/// Component APIs
public class MGFeed {
    
    /**
     Initializes a new feed with the provided data.
     
     - Parameters: all parameter to pass in the MGFeed object
     - data: The data to pass in the initializer
     
     - Returns: The module component
     */
    public init(data: MGFeedData) {
        feedData = data
        controller = _controller
        controller.feedData = data
        controller.didTapMenu = { feedController in
            self.didCloseFeed(self)
        }
    }
    
    /**
     This is the initial view controller of the module MGFeed.
     
     - Returns: The initial view controller
     */
    public var controller: MGFeedController!
    
    /**
     This is data passed to the initialised object MGFeed.
     
     - Returns: The data
     */
    public var feedData:MGFeedData!
    
    /**
     This closure is called only when the MGFeed module is closed.
     
     - Returns: Closed module
     */
    public var didCloseFeed:((MGFeed) -> ())!
    
    private var _controller: MGFeedController? {
        return _initialViewController as? MGFeedController
    }
    
    private var _initialViewController: UIViewController {
        return _storyboard.instantiateViewController(withIdentifier: _initialViewControllerIdentifier)
    }
    
    private var _initialViewControllerIdentifier:String {
        return initialViewControllerIdentifier
    }
    
    private var _storyboard:UIStoryboard {
        return UIStoryboard(name: _storyboardName, bundle: _storyboardBundle)
    }
    
    private var _storyboardName:String {
        return storyboardName
    }
    
    private var _storyboardBundle:Bundle {
        let podBundle = Bundle(for: MGFeed.self)
        let bundleURL = podBundle.url(forResource: resourceName, withExtension: resourceExtension)
        let bundle = Bundle(url: bundleURL!)!
        return bundle
    }

}

fileprivate let storyboardName = "MGFeed"
fileprivate let initialViewControllerIdentifier = "MGFeedController"
fileprivate let resourceName = "MGFeedKit"
fileprivate let resourceExtension = "bundle"

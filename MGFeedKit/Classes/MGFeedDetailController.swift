// 
//  MGFeedDetailController.swift
//
//  Created by harald bregu on 28/02/2019.
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

import UIKit
import SDWebImage
import GSImageViewerController

/// :nodoc:
class MGFeedDetailController: UIViewController {
    @IBOutlet var tableView: UITableView!
    public var feedDataItem:MGFeedDataItem!

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = UIColor("#15161D")
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = UIColor("#15161D")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: optionImage, style: .plain, target: self, action: #selector(shareFeedItem))
//        tableView.backgroundColor = UIColor("#15161D")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    @objc func shareFeedItem() {
        
        let items = [feedDataItem.itemUrl!]
        let activityIndicator = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityIndicator, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }

}

/// :nodoc:
extension MGFeedDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MGFeedDetailViewCell") as? MGFeedDetailViewCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.itemTitleLabel.text = feedDataItem.title

        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.white)
        cell.itemImageView.sd_setImage(with: URL(string: feedDataItem.imageUrl))
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        let stringFromDate = dateFormatterGet.string(from: feedDataItem.author_pubDate ?? Date())
//        let pubDate = DateFormatter.formatedDate(dateString: stringFromDate, fromFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "dd MMM yyyy")
//        cell.itemDateAuthorLabel.text = pubDate
//        cell.itemDateAuthorLabel.textColor = UIColor("#F3F7F8")
        
//        cell.itemDescriptionContentLabel.text = feedDataItem.itemDescription.byConvertingHTMLToPlainText()
//        cell.itemDescriptionContentLabel.textColor = UIColor("#F3F7F8")
        
//        UITapGestureRecognizer(addToView: cell.itemImageView) { [unowned self] gesture in
//            let imageInfo = GSImageInfo(image: cell.itemImageView.image ?? UIImage(), imageMode: .aspectFit, imageHD: nil)
//            let transitionInfo = GSTransitionInfo(fromView: cell.itemImageView)
//            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
//            self.present(imageViewer, animated: true, completion: nil)
//        }
        
        return cell
    }
}


/// :nodoc:
extension MGFeedDetailController {
    
//    private var shareImage:UIImage {
//        let shareIcon = IoniconsType.androidShare
//        let icon = FontType.ionicons(shareIcon)
//        return UIImage(icon: icon, size: playerSize, textColor: secondaryColor.withAlphaComponent(0.4), backgroundColor: .clear)
//    }
//
//    private var optionImage:UIImage {
//        let iconOption = IoniconsType.androidShare
//        let type = FontType.ionicons(iconOption)
//        return UIImage(icon: type, size: CGSize(width: 30, height: 30), textColor: #colorLiteral(red: 0.6666666667, green: 0.6470588235, blue: 0.7098039216, alpha: 1), backgroundColor: .clear)
//    }
//
//    private var playerSize:CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//
//    private var primaryColor:UIColor {
//        return UIColor("#E21C3A")
//    }
//
//    private var secondaryColor:UIColor {
//        return UIColor.white
//    }
    
}

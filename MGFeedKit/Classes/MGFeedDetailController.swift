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


public class MGFeedDetailController: UIViewController {
    @IBOutlet var tableView: UITableView!
    public var item:MGFeedItem!
    public var assets:MGAsset!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = assets.string.title
        navigationItem.title = assets.string.title
        
        view.backgroundColor = assets.color.backgroundView
        navigationController?.navigationBar.tintColor = assets.color.navigationBarTint
        navigationController?.navigationBar.barTintColor = assets.color.navigationBar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: optionImage, style: .plain, target: self, action: #selector(shareFeedItem))

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = assets.color.backgroundTableView
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 112 + 25, bottom: 0, right: 0)
        tableView.separatorColor = assets.color.tableViewSeparator
    }
    
    @objc func shareFeedItem() {
        
        let items = [item.itemUrl!]
        let activityIndicator = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityIndicator, animated: true)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }

}

extension MGFeedDetailController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MGFeedDetailViewCell") as? MGFeedDetailViewCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.itemTitleLabel.text = item.title

        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.white)
        cell.itemImageView.sd_setImage(with: URL(string: item.imageUrl))
        
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        let stringFromDate = dateFormatterGet.string(from: item.author_pubDate ?? Date())
//        let pubDate = DateFormatter.formatedDate(dateString: stringFromDate, fromFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "dd MMM yyyy")
//        cell.itemDateAuthorLabel.text = pubDate
//        cell.itemDateAuthorLabel.textColor = UIColor("#F3F7F8")
//
//        cell.itemDescriptionContentLabel.text = DateFormatter.formatedDate.itemDescription.byConvertingHTMLToPlainText()
//        cell.itemDescriptionContentLabel.textColor = UIColor("#F3F7F8")
//
//        UITapGestureRecognizer(addToView: cell.itemImageView) { [unowned self] gesture in
//            let imageInfo = GSImageInfo(image: cell.itemImageView.image ?? UIImage(), imageMode: .aspectFit, imageHD: nil)
//            let transitionInfo = GSTransitionInfo(fromView: cell.itemImageView)
//            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
//            self.present(imageViewer, animated: true, completion: nil)
//        }
        
        cell.backgroundColor = assets.color.backgroundViewCell
        cell.contentView.backgroundColor = assets.color.backgroundViewCell
        cell.itemTitleLabel.textColor = assets.color.cellTint

        return cell
    }
}

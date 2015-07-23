//
//  InterestViewController.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/18/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//
//Interest Info + posts

import UIKit

class InterestViewController: UIViewController {
    

    //MARK: - Public API
    var interest: Interest! = Interest.createInterests()[0]
        
    //MARK: - Private
    @IBOutlet weak var tableView: UITableView!
    private let tableHeaderHight: CGFloat = 350.0
    private let tableViewCutAway: CGFloat = 50.0
    
    private var headerView: InterestHeaderView!
    private var headerMaskLayer: CAShapeLayer!
    
    //Data source
    private var posts = [Post]()
    
    private var newPostButton: ActionButton!
    
    //MARK: - viewController Life Circle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    //Making the status bar white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 387.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        headerView = tableView.tableHeaderView as! InterestHeaderView
        headerView.delegate = self
        headerView.interest = interest
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        
        let nib: UINib = UINib(nibName: "Interest1TableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PostCellWithImage")
        
        let nib2: UINib = UINib(nibName: "interest2TableViewCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "PostCellWithoutImage")
        
        updateHeaderView()
        
        createNewPostButton()
        
        fetchPost()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    func updateHeaderView() {
        let effectiveHeight = tableHeaderHight - tableViewCutAway/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderHight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableViewCutAway/2
            
        }
        
        headerView.frame = headerRect
        
        //Cut away 
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height - tableViewCutAway))
        headerMaskLayer?.path = path.CGPath
        
    }
    
    func createNewPostButton() {
        
        newPostButton = ActionButton(attachedToView: self.view, items: [])
        
        newPostButton.action = { button in
            self.performSegueWithIdentifier("ShowPostComposer", sender: nil)
            
        }
        // set the button's backgroundColor
        
    }
    
    func fetchPost() {
        
        posts = Post.allPosts
        tableView.reloadData()
    }
    
    //MARK: - Navigation 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Show Comment" {
            
            let commentViewController = segue.destinationViewController as! CommentViewController
            commentViewController.post = sender as! Post
        }
    }
    

}


extension InterestViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]
        
        if post.postImage != nil {
            //With image
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCellWithImage", forIndexPath: indexPath) as! Interest1TableViewCell
            
            cell.post = post
            cell.delegate = self
            
            return cell
        } else {
            //Without image
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCellWithoutImage", forIndexPath: indexPath) as! interest2TableViewCell
            
            cell.post = post
            cell.delegate = self
            
            return cell
        }
    }
}

extension InterestViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("Show Comment", sender: self.posts[indexPath.row])
    }
    
}



extension InterestViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        updateHeaderView()
        
        let offsetY = scrollView.contentOffset.y
        let adjustment: CGFloat = 130.0
        
        if (-offsetY) > (tableHeaderHight + adjustment) {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if (-offsetY) > (tableHeaderHight + 20) {
            
            self.headerView.pullDownToCloseLabel.hidden = false
        } else {
            
            self.headerView.pullDownToCloseLabel.hidden = true
        }
        
        
    }
    
}


extension InterestViewController: InterestHeaderViewDelegate {
    
    func closeButtonClicked() {
        print("close button clicked gets called")
        print("dismiss viewController")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension InterestViewController: Interest1TableViewDelegate {
    
    func commentButtonClicked(post: Post) {
        
        self.performSegueWithIdentifier("Show Comment", sender: post)
    }
}

extension InterestViewController: Interest2TableViewCellDelegate {
    
    func commentButtonClicked2(post: Post) {
        
        self.performSegueWithIdentifier("Show Comment", sender: post)
    }
}























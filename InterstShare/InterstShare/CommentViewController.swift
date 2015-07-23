//
//  CommentViewController.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/21/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    // MARK: - Public API
    var post: Post!
    
    @IBOutlet weak var tableView: UITableView!
    private var commentButton: ActionButton!
    private var comments = [Comment]()
    
    //MARK: - View Controller LifeCycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PostWithImageTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PostWithImage")
        
        let nib2 = UINib(nibName: "PostWithoutImageTableViewCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "PostWithoutImage")
        
        let nib3 = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.registerNib(nib3, forCellReuseIdentifier: "Comment Cell")
        
        fetchComment()
        
        //Configure the navigation bar 
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "EE8222")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        title = "Comments"
        
        //Configure the tableview
        // Make the tableview to have dynamic height
        // Make the row height dynamic
        tableView.estimatedRowHeight = 387.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clearColor()
        tableView.allowsSelection = false
        
        // Making the float button
        createNewPostButton()
        
    }

    
    func createNewPostButton() {
        
        commentButton = ActionButton(attachedToView: self.view, items: [])
        commentButton.action = { button in
            self.performSegueWithIdentifier("Post Comment Composer", sender: nil)
        }
    }
    
    private func fetchComment() {
        
        comments = Comment.allComments()
        tableView.reloadData()
    }

    //MARK: - Navigation 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }

}


extension CommentViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (comments.count + 1) // All the comments and a post
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if post.postImage == nil {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("PostWithoutImage", forIndexPath: indexPath) as! PostWithoutImageTableViewCell
                
                cell.post = post
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("PostWithImage", forIndexPath: indexPath) as! PostWithImageTableViewCell
                
                cell.post = post
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Comment Cell", forIndexPath: indexPath) as! CommentTableViewCell
            
            cell.comment = self.comments[indexPath.row - 1]
            return cell
        }
        
    }
    
}














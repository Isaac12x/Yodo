//
//  FirstViewController.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 21/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import UIKit
import MBProgressHUD

class TheGreatQuote: UITableViewController{

    var quote = [Quote]()
    
    @IBOutlet weak var viewToDownload: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navigationItem.title = "YODO"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.27, green:0.73, blue:0.86, alpha:1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "New-40")!, style: .Plain, target: self, action: "downloadQuote:")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
    
    }

    // MARK: - Download a quote from Andrux
    /// Call AndruxClient to download a quote
    
    func downloadQuote(sender: UIBarButtonItem){
        self.showLoadingHUD()
        
        AndruxClient.sharedInstance().taskForGet{ (response, error) in
            guard let response = response else{
                return
            }
            
            let addQuote = Quote(dictionary: response)
            self.quote.append(addQuote)
            
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.hideLoadingHUD()
            }
            
        }
        
    }
    
    // MARK: - TableView Protocol Conformance
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableOfQuotesCell") as! TableOfQuotesCell
        
        let quoted = quote[indexPath.row]
        
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        cell.quoteString?.text = "\(quoted.quoteContent)"
        cell.quoteAuthor?.text = "\(quoted.quoteAuthor)"

        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quote.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = (self.storyboard?.instantiateViewControllerWithIdentifier("SayItInYodasWords")) as! SayItInYodasWords
        let quoted = quote[indexPath.row]
        controller.quoteToUpgrade = quoted.quoteContent
        
        
        self.navigationController?.pushViewController(controller, animated: true)

        
    }
    
    /* Helper DisplayFeedback with activityviewcontrollers  */
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    

}


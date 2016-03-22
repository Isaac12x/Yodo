//
//  FirstViewController.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 21/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import Crashlytics

class TheGreatQuote: UITableViewController, NSFetchedResultsControllerDelegate{
    
    // MARK: - Variables & Outlets

    var quote = [Quote]()
    
    @IBOutlet weak var viewToDownload: UIView!

    
    // MARK: - Application Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.navigationItem.title = "YODO"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.27, green:0.73, blue:0.86, alpha:1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "New-40")!, style: .Plain, target: self, action: "downloadQuote:")
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self

    }

    
    // MARK: - Download a quote from Andrux
    /// Call AndruxClient to download a quote
    
    func downloadQuote(sender: UIBarButtonItem){
        self.showLoadingHUD()
        
        AndruxClient.sharedInstance().taskForGet{ (response, error) in
  
            guard let response = response else{
                return
            }
                    
            let addQuote = Quote(dictionary: response, context: self.sharedContext)
            self.quote.append(addQuote)

            CoreDataStackManager.sharedInstance().saveContext()

            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.hideLoadingHUD()
            }
            
        }
        
    }
    
    // MARK: - TableView Protocol Conformance
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableOfQuotesCell") as! TableOfQuotesCell
        
        let quoted = fetchedResultsController.objectAtIndexPath(indexPath) as! Quote
        
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        cell.quoteString?.text = "\(quoted.quoteContent)"
        cell.quoteAuthor?.text = "\(quoted.quoteAuthor)"

        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = (self.storyboard?.instantiateViewControllerWithIdentifier("SayItInYodasWords")) as! SayItInYodasWords
        let quoted = fetchedResultsController.objectAtIndexPath(indexPath) as! Quote
        controller.quote = quoted
        
        
        self.navigationController?.pushViewController(controller, animated: true)

        
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            switch (editingStyle) {
            case .Delete:
                
                // Here we get the actor, then delete it from core data
                let quote = fetchedResultsController.objectAtIndexPath(indexPath) as! Quote
                sharedContext.deleteObject(quote)
                CoreDataStackManager.sharedInstance().saveContext()
                
            default:
                break
            }
    }
    
    
    func configureCell(cell: UITableViewCell, withQuote: Quote){
        cell.textLabel?.text = withQuote.quoteContent
        cell.textLabel?.text  = withQuote.quoteAuthor
    }
    
    
    /* Helper DisplayFeedback with activityviewcontrollers  */
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    // MARK: - Core Data
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    
    // MARK: - NSFetchedResultsControllerdelegateConformance
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Quote")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "quoteAuthor", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! TableOfQuotesCell
            let quote = controller.objectAtIndexPath(indexPath!) as! Quote
            self.configureCell(cell, withQuote: quote)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }



}


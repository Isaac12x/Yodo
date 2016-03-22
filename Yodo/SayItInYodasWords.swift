//
//  SecondViewController.swift
//  Yodo
//
//  Created by Isaac Albets Ramonet on 21/03/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import UIKit
import MBProgressHUD
import EZSwiftExtensions

class SayItInYodasWords: UIViewController {

    var quoteToUpgrade: String!
    var yodasWisdom: String!
    var yodaChargedWisdom: YodaWords!
    
    @IBOutlet weak var preUpgrade: UITextView!
    @IBOutlet weak var quoteUpgraded: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Configure the view
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundSecondView")!)
        
        // Navigation
        self.navigationItem.title = "YODO"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Christmas Penguin-40")!, style: UIBarButtonItemStyle.Plain, target: self, action: "getTheWisdomOfYoda:")
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        // Textfields
        self.quoteUpgraded.selectable = true
        self.preUpgrade.text = quoteToUpgrade
        
        // MARK: Added guidance - will update to a popOver
        if ApplicationControlers.justOnce{
            NSTimer.runThisAfterDelay(seconds: 1.5) { () -> () in
                let alert = SweetAlert().showAlert("Hey,", subTitle: "Press the penguin foreigner!", style: AlertStyle.Success)
                alert.animateAlert()
                ApplicationControlers.justOnce = false
            }
        }
        
        if ApplicationControlers.isDownloaded {
            //self.quoteUpgraded.text = yodaChargedWisdom.wisdom

        } else {
            
        }
       
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Grab a quote and transform the quote to Yoda talk

    func getTheWisdomOfYoda(sender: UIBarButtonItem){
        self.preyForYodasWisdom()

    }
    
    /// Make a call to the Yodaclient and place AlertViews in the view
    func preyForYodasWisdom(){
        self.showLoadingHUD()
        
        YodaClient.sharedInstance().taskForGet(quoteToUpgrade){ (response, error) in
            
            guard let response = response else{
                return
            }
            let dataString = NSString(data:response as! NSData, encoding:NSUTF8StringEncoding) as! String
            let advice = YodaWords(wisdom: dataString)
            self.yodasWisdom = advice.wisdom
            
            ApplicationControlers.isDownloaded = true
            dispatch_async(dispatch_get_main_queue()){
                self.updateUI()
                self.hideLoadingHUD()
            }
        }
    }

    // MARK: - Update th eUI
    
    func updateUI(){
        self.preUpgrade.text = quoteToUpgrade
        self.quoteUpgraded.text = yodasWisdom
    }
    
    
    /* Helper DisplayFeedback with activityviewcontrollers  */
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Downloading Yoda's infinite Wisdom..."
    }

    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    
    
    // MARK: - Next steps
    // Make the quote shearable
    func shareTheUltimateWisdom(sender: UITextView){
        
    }
    
    // Add different downloading sentences, research funny quotes
    var whileConnectingToYoda = []

}


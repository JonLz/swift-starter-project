//
//  ViewController.swift
//  TCCountdown
//
//  Created by Jon on 12/3/15.
//  Copyright © 20.6 Second Wind, LLC. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

class ViewController: UIViewController {

    let dayImageView = UIImageView()
    let dayDescriptionLabel = UILabel()
    let dayLinkButton = UIButton(type: UIButtonType.RoundedRect)
    var URL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        
        self.view.addSubview(dayImageView)
        self.view.addSubview(dayDescriptionLabel)
        self.view.addSubview(dayLinkButton)
        
        self.dayImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.dayImageView.clipsToBounds = true
        self.dayImageView.userInteractionEnabled = true
        self.dayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "loadImageViewData"))
        
        self.dayImageView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(300)
        }
        
        self.dayDescriptionLabel.textAlignment = NSTextAlignment.Center
        self.dayDescriptionLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        self.dayDescriptionLabel.font = UIFont.systemFontOfSize(28)
        self.dayDescriptionLabel.numberOfLines = 3;
        self.dayDescriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.dayDescriptionLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.dayImageView.snp_bottom).offset(30)
        }
        
        self.dayLinkButton.setTitle("...", forState: UIControlState.Normal)
        self.dayLinkButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.dayLinkButton.backgroundColor = UIColor.blueColor()
        self.dayLinkButton.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.dayDescriptionLabel.snp_bottom).offset(30)
        }

        self.loadImageViewData()
        self.dayDescriptionLabel.text = "..."

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.displayAlert()
    }
   
    // UI Setup
    func loadImageViewData() -> ()
    {
        Alamofire.request(.GET, "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC").validate().responseJSON { response in
            switch response.result
            {
            case .Success(let JSON):
                if let data = JSON["data"],
                        URL = data!["url"],
                  image_URL = data!["image_url"]
                {
                    let URL = URL as! String
                    self.URL = NSURL(string: URL)!
                    let URLComponents = NSURLComponents(string: URL)
                    let URLPath = URLComponents!.path!
                    
                    self.dayImageView.af_setImageWithURL(NSURL(string:image_URL as! String)!)
                    self.dayDescriptionLabel.text = "Now Viewing\n\(URLPath)"
                    self.dayLinkButton.setTitle("View Animated GIF", forState: UIControlState.Normal)
                    self.dayLinkButton.addTarget(self, action: "tappedButton", forControlEvents: UIControlEvents.TouchUpInside)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func tappedButton() -> ()
    {
        UIApplication.sharedApplication().openURL(self.URL)
    }
    
    // Alert View
    func displayAlert() -> ()
    {
        let message = self.createCountdownMessage()
        let alertViewController = UIAlertController(title: "Countdown!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertViewController.addAction(okAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    func createCountdownMessage() -> String
    {
        let currentDate = NSDate()
        let endOfYearDate = NSDate(dateString: "2016-01-01")
        
        let sysCalendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.Day
        let dateComponents = sysCalendar.components(unitFlags, fromDate: currentDate, toDate: endOfYearDate, options: [])

        let dayString = dateComponents.day > 1 ? "days" : "day"
        return "\(dateComponents.day) \(dayString) until the New Year!"
        
    }


}


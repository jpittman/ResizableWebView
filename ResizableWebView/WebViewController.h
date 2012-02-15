//
//  WebViewController.h
//  ResizableWebView
//
//  Created by Johnnie Pittman on 2/14/12.
//  Copyright (c) 2012 Group 6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIButton *sizeButton;
    IBOutlet UILabel *textLabel;
    IBOutlet UIWebView *aWebView;
}

@property (nonatomic, retain) IBOutlet UIButton *sizeButton;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIWebView *aWebView;


@end

//
//  WebViewController.h
//  ResizableWebView
//
//  Created by Johnnie Pittman on 2/14/12.
//  Copyright (c) 2012 Group 6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    
    UIButton *addButton;
    UIButton *removeButton;
    UILabel *heightLabel;
    UILabel *widthLabel;
    UIWebView *aWebView;
    NSString *content;
    BOOL loaded;
}

@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *removeButton;
@property (nonatomic, retain) IBOutlet UILabel *heightLabel;
@property (nonatomic, retain) IBOutlet UILabel *widthLabel;
@property (nonatomic, retain) IBOutlet UIWebView *aWebView;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) BOOL loaded;

- (IBAction)addContent;
- (IBAction)removeContent;


@end

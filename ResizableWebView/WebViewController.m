//
//  WebViewController.m
//  ResizableWebView
//
//  Created by Johnnie Pittman on 2/14/12.
//  Copyright (c) 2012 Group 6. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize sizeButton, textLabel, aWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight)];
    
    // set the webview delegate to our view controller.
    [self.aWebView setDelegate:self];
    
    // disable scrolling inside of the webview.
    [self.aWebView.scrollView setScrollEnabled:NO];

    // Adding the action to our button.
    [self.sizeButton addTarget:self action:@selector(addContent) 
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Button methods

- (void) addContent 
{
    
    // Building the html string we want to load.
    NSString *boiler = @"<html><head><meta name=\"viewport\" content=\"width=320\"/>"
                        "</head><body>%@</body></html>";
    NSString *content = @"<h1>This is a title.</h1>";
    NSString *html = [[NSString alloc] initWithFormat:boiler, content];
    
    // load our html string into the webview.
    [self.aWebView loadHTMLString:html baseURL:nil];
    
    // Change out the action that the button can take and replace it's text.
    [self.sizeButton removeTarget:self action:@selector(addContent) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.sizeButton addTarget:self action:@selector(removeContent) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.sizeButton setTitle:@"Remove Content From WebView" forState:UIControlStateNormal];
    
}

- (void) removeContent {

    // Load up an empty string into the webview.
    [self.aWebView loadHTMLString:@"" baseURL:nil];
    
    // Change out the action that the button can take and replace it's text.
    [self.sizeButton removeTarget:self action:@selector(removeContent) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.sizeButton addTarget:self action:@selector(addContent) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.sizeButton setTitle:@"Add Content To WebView" forState:UIControlStateNormal];

}

#pragma mark - UIWebView Delegate Methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError got called with error: %@", [error localizedDescription]);
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
//{
//    NSLog(@"shouldStartLoadWithRequest got called.");
//    return YES;
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView 
//{
//    NSLog(@"DidStartLoad got called.");
//}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//    NSLog(@"DidFinishLoad got called.");
    
    // our bit of javascript to determine the height of the html content.
    NSString *jsString = @"function getDocHeight() {"
                         "var D = document;"
                         "return Math.max("
                         "Math.max(D.body.scrollHeight, D.documentElement.scrollHeight),"
                         "Math.max(D.body.offsetHeight, D.documentElement.offsetHeight),"
                         "Math.max(D.body.clientHeight, D.documentElement.clientHeight)"
                         ");"
                         "}"
                         "getDocHeight();";

    
    // Execute our javascript against the html and return the height.
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:jsString];
    CGFloat height = [content floatValue];
    NSLog(@"height of the text is: %f", height);
    
    // Adjust the height of the webivew based upon the content.
    CGRect frame = [webView frame];
    frame.size.height = height;
    [webView setFrame:frame];
    
    // set our label indicating the new height of the view.
    [self.textLabel setText:[NSString localizedStringWithFormat:@"%.1f", height]];
    
    
//    if ([[self delegate] respondsToSelector:@selector(webViewController:webViewDidResize:);])
//    {
//        [[self delegate] webViewController:self webViewDidResize:frame.size];
//    }
}

@end

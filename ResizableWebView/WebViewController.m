//
//  WebViewController.m
//  ResizableWebView
//
//  Created by Johnnie Pittman on 2/14/12.
//  Copyright (c) 2012 Group 6. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

- (void)adjustHeight:(CGFloat)height forView:(UIView *)aView;
- (void)adjustScrollViewHeight:(CGFloat)height;

@end

@implementation WebViewController

@synthesize addButton, removeButton, heightLabel, widthLabel, aWebView;

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
    
    // setting the size of the screen for scrolling.
    [self adjustScrollViewHeight:460];
    
    // Do any additional setup after loading the view from its nib.
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight)];
    
    // disable scrolling inside of the webview.
    [self.aWebView.scrollView setScrollEnabled:NO];
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
    return YES;
}

# pragma mark - Button methods

- (IBAction)addContent 
{
    
    // Boilerplate html.  Note the meta tag included.
    NSString *boiler = @"<html><head><meta name=\"viewport\" content=\"width=280\"/>"
                        "</head><body>%@</body></html>";

    // Grab the contents of a html file and return it as a string.
    NSError *error;
    NSString *loremPath = [[NSBundle mainBundle] pathForResource:@"lorem" ofType:@"html"];
    NSStream *contents = [NSString stringWithContentsOfFile:loremPath 
                                                   encoding:NSASCIIStringEncoding error:&error];
    
    // Combine the boilerplate and the file contents.
    NSString *html = [[NSString alloc] initWithFormat:boiler, contents];
    
    // load our html string into the webview.
    [self.aWebView loadHTMLString:html baseURL:nil];
    
}

- (IBAction)removeContent 
{
 
    // Reset the height that was originally used for the webview.
    [self adjustHeight:150.0 forView:self.aWebView];

    // Load up an empty string into the webview.
    [self.aWebView loadHTMLString:@"" baseURL:nil];

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
    NSString *jsHeight = @"function getDocHeight() {"
                         "var D = document;"
                         "return Math.max("
                         "Math.max(D.body.scrollHeight, D.documentElement.scrollHeight),"
                         "Math.max(D.body.offsetHeight, D.documentElement.offsetHeight),"
                         "Math.max(D.body.clientHeight, D.documentElement.clientHeight)"
                         ");"
                         "}"
                         "getDocHeight();";

    
    // Execute our javascript against the html and return the height.
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:jsHeight] floatValue];
    
    // Adjust the height of the webivew based upon the content.
    [self adjustHeight:height forView:webView];
    
    // set our label indicating the new height of the view.
    [self.heightLabel setText:[NSString localizedStringWithFormat:@"%.1f", height]];
    
    
//    if ([[self delegate] respondsToSelector:@selector(webViewController:webViewDidResize:);])
//    {
//        [[self delegate] webViewController:self webViewDidResize:frame.size];
//    }
}

#pragma mark - Height Methods

// testing a little convienance method handling height changes in a view.
- (void)adjustHeight:(CGFloat)height forView:(UIView *)aView 
{
    CGRect frame = [aView frame];
    frame.size.height = height;
    [aView setFrame:frame];

    if (height > 150) {
        CGFloat scrollHeight = height + 110 + 20;
        [self adjustScrollViewHeight:scrollHeight];
    } else {
        [self adjustScrollViewHeight:460];
    }
}

- (void)adjustScrollViewHeight:(CGFloat)height 
{
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    tempScrollView.contentSize=CGSizeMake(320,height);
}

#pragma mark - Orientation Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{

}


@end

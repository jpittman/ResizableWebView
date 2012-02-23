//
//  WebViewController.m
//  ResizableWebView
//
//  Created by Johnnie Pittman on 2/14/12.
//  Copyright (c) 2012 Group 6. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

- (void)adjustWebView;
- (void)adjustHeight:(CGFloat)height forView:(UIView *)aView;
- (void)adjustWidth:(CGFloat)width forView:(UIView *)aView;
- (void)adjustScrollViewHeight:(CGFloat)height;
- (CGFloat)findHeightForWebView:(UIWebView *)webView;

@end

@implementation WebViewController

@synthesize addButton, removeButton, heightLabel, widthLabel, aWebView, loaded;

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

//- (void)viewDidLayoutSubviews 
//{
//    NSLog(@"Did Layout Subviews Called.");
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setting the size of the screen for scrolling.
    CGFloat height = CGRectGetHeight(self.view.bounds);
    [self adjustScrollViewHeight:height];
    
    // Do any additional setup after loading the view from its nib.
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight)];
    
    // disable scrolling inside of the webview.
    [self.aWebView.scrollView setScrollEnabled:NO];
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//
//}

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
    
    [self setLoaded:YES];
    
}

- (IBAction)removeContent 
{
    // Load up an empty string into the webview.
    [self.aWebView loadHTMLString:@"" baseURL:nil];
    
    // Reset the height that was originally used for the webview.
    [self adjustHeight:150.0 forView:self.aWebView];
    
    [self setLoaded:NO];

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
    
    [self adjustWebView];
    
}

#pragma mark - Height Methods

- (void)adjustWebView 
{
    // get the width of the webview 
    CGFloat width = self.aWebView.frame.size.width;
    
    // if content is loaded into the webview, set the viewport in the html.
    if (self.loaded) {
        NSString *jsViewPort = @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false);";
        NSString *jsScript = [NSString stringWithFormat:jsViewPort, (NSInteger)width];
        [self.aWebView stringByEvaluatingJavaScriptFromString:jsScript];
    }
    
    // Update the label indicating the width of the webview.
    [self.widthLabel setText:[NSString localizedStringWithFormat:@"%.1f", width]];

    // grab the height for the webview loaded with content.
    CGFloat height = [self findHeightForWebView:self.aWebView];
    
    // Adjust the height of the webivew based upon the content.
    [self adjustHeight:height forView:self.aWebView];

}

// testing a little convienance method handling height changes in a view.
- (void)adjustHeight:(CGFloat)height forView:(UIView *)aView 
{
    
    NSLog(@"Adjust Height Called.");
    
    CGRect frame = [aView frame];

    CGFloat scrollHeight;
    if (self.loaded) {
        frame.size.height = height;
        scrollHeight = height + 110 + 20;
    } else {
        frame.size.height = 150;
        scrollHeight = CGRectGetHeight(self.view.bounds);
    }
    
    [aView setFrame:frame];
    [self adjustScrollViewHeight:scrollHeight];
    
    // set our label indicating the new height of the view.
    [self.heightLabel setText:[NSString localizedStringWithFormat:@"%.1f", frame.size.height]];
    
    NSLog(@"Scroll Height is: %f", scrollHeight);

}

- (void)adjustWidth:(CGFloat)width forView:(UIView *)aView {
    
}


- (void)adjustScrollViewHeight:(CGFloat)height 
{
    
    NSLog(@"Adjust Scroll Height Called.");
    NSLog(@"Height is: %f", height);

    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    tempScrollView.contentSize=CGSizeMake(width, height);
}

- (CGFloat)findHeightForWebView:(UIWebView *)webView
{
    NSLog(@"Find Height Called.");
    
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
    NSLog(@"The web view's height is: %f", height);
    return height;
}

#pragma mark - Orientation Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"Will Rotate To Called.");
//    NSString *script;
//    NSString *jsViewPort = @"var viewport = document.querySelector(\"meta[name=viewport]\");";
//    NSString *jsViewPort = @"document.querySelector(\"meta[name=viewport]\");";
//                            "viewport.setAttribute('content', 'width=%@;');";
//    NSString *jsViewPort = @"document.getElementById('viewport').setAttribute('content','width=%@;');";
    
//    switch (toInterfaceOrientation) {
//        case UIInterfaceOrientationPortrait:
//            script = [[NSString alloc] initWithFormat:jsViewPort, @"280"];
//            NSLog(@"Portrait");
//            break;
//            
//        case UIInterfaceOrientationPortraitUpsideDown:
//            script = [[NSString alloc] initWithFormat:jsViewPort, @"280"];
//            NSLog(@"Upside down.");
//            break;
//            
//        case UIInterfaceOrientationLandscapeLeft:
//            script = [[NSString alloc] initWithFormat:jsViewPort, @"440"];
//            NSLog(@"Landscape Left");
//            break;
//            
//        case UIInterfaceOrientationLandscapeRight:
//            script = [[NSString alloc] initWithFormat:jsViewPort, @"440"];
//            NSLog(@"Landscape Right");
//            break;
//        
//        // Not used.  Here for completeness.
//        default:
//            break;
//    }
    
//    NSString *jsViewPort = @"function getViewPort() {"
//                            "var D = document;"
//                            "return D.querySelector('meta[name=viewport]');"
//                            "}"
//                            "getViewPort();";
    
//    NSString *result = [self.aWebView stringByEvaluatingJavaScriptFromString:jsViewPort];
//    NSLog(@"%@", result);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
//    NSLog(@"Did Rotate From Called.");
    // set our label indicating the new height of the view.
    [self adjustWebView];
}


@end

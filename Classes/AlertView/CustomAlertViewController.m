//
//  CustomAlertView.m
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 17/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import "CustomAlertViewController.h"
#import "IndigenousPortalVideoAppDelegate.h"


@implementation CustomAlertViewController

@synthesize webView;
@synthesize background;

- (void)dealloc 
{
    if(webView) 
    {
        [webView release];
    }
    
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    self.webView.scalesPageToFit = NO;
    [self setupView];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{
    LOG_CURRENT_METHOD;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    LOG_CURRENT_METHOD;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    LOG_CURRENT_METHOD;
    
   
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
    if (error != NULL && [error code] != -999) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: [error localizedDescription]
                                   message: [error localizedFailureReason]
                                   delegate:nil
                                   cancelButtonTitle:@"OK" 
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
}

- (IBAction)closeAlert 
{
    LOG_CURRENT_METHOD;
    
    [self.view removeFromSuperview];
    //[[UIApplication sharedApplication] terminate]; // terminate app properly
}

- (void)setupView 
{
    [self setBackgroundImage];
    
    if([IndigenousPortalVideoAppDelegate get].loadError == 1) 
    {
        [self loadNetworkError];
    } 
    else 
    {
        [self loadWifiError];
    }
}

- (void)setBackgroundImage 
{
	UIImageView *customBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-background.png"]];
	self.background = customBackground;
	[customBackground release];
	
	[self.view addSubview:background];
	LOG(@"Added background subview %@ to %@", background, self.view);
	[self.view sendSubviewToBack:background];
}
    
-(void)loadNetworkError 
{
    LOG_CURRENT_METHOD;
    
    NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"network" ofType:@"html" inDirectory:@"www"];
    NSURL *helpURL = [NSURL fileURLWithPath:helpPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:helpURL]];
}

- (void)loadWifiError 
{
    LOG_CURRENT_METHOD;
    
    NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"wifi" ofType:@"html" inDirectory:@"www"];
    NSURL *helpURL = [NSURL fileURLWithPath:helpPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:helpURL]];
}


@end

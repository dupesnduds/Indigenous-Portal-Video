//
//  NavViewController.m
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 14/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import "NavViewController.h"
#import "VideoViewController.h"
#import "IndigenousPortalVideoAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation NavViewController


@synthesize background;
@synthesize avc;
@synthesize what;


- (void)dealloc 
{
    [avc release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    LOG_CURRENT_METHOD;
    
    [super viewDidLoad];
    [self setBackgroundImage]; 
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {}

- (IBAction)showVideoList 
{
    LOG_CURRENT_METHOD;
    
    [IndigenousPortalVideoAppDelegate playEffect:kEffectButton];
    self.what =3;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self switchView];
}

- (void)setBackgroundImage 
{
	LOG_CURRENT_METHOD;
    
	UIImageView *customBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main-nav-163dpi.png"]];
	self.background = customBackground;
	[customBackground release];
	
	[self.view addSubview:background];
	LOG(@"Added background subview %@ to %@", background, self.view);
	[self.view sendSubviewToBack:background];
}

- (void)switchView 
{
    LOG_CURRENT_METHOD;
    
    
    VideoViewController *tavc = [[VideoViewController alloc] initWithNibName:@"VideoView" bundle:nil];
    self.avc = tavc;
    [tavc release];
    
    UIView *currentView = self.view;
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [currentView superview];
    // remove the current view
    [currentView removeFromSuperview];
    
    switch(self.what) 
    {
        case 3:
            // replace with avc
            [theWindow addSubview:[avc view]];
            break;
    }
    
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.85];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[theWindow layer] addAnimation:animation forKey:@"swap"];    
}


@end

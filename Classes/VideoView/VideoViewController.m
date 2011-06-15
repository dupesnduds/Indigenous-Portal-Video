//
//  VideoViewController.m
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 14/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import "VideoViewController.h"
#import "HtmlViewController.h"
#import "IndigenousPortalVideoAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation VideoViewController


@synthesize background;
@synthesize videoTable;
@synthesize videoTableCell;
@synthesize videoIcon;
@synthesize cellString;
@synthesize hvc;
@synthesize what;


- (void)dealloc 
{
    [hvc release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    LOG_CURRENT_METHOD;
    
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

#pragma mark -
#pragma mark Delegate 
- (void)aboutViewControllerDidFinish:(AboutViewController *)controller 
{
    LOG_CURRENT_METHOD;
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Actions
- (IBAction)showAbout 
{  
    LOG_CURRENT_METHOD;
	
    [IndigenousPortalVideoAppDelegate playEffect:kEffectButton];
    [IndigenousPortalVideoAppDelegate playEffect:kEffectPage];
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	controller.delegate = self;
	
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (IBAction)refreshList
{
    LOG_CURRENT_METHOD;
    
    [IndigenousPortalVideoAppDelegate playEffect:kEffectButton];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString * newsAddress = @"http://www.tumunu.com/iportal/video-feed.php";
    [IndigenousPortalVideoAppDelegate get].what = 2;
    [[IndigenousPortalVideoAppDelegate get] grabFeed:newsAddress];
    [self.videoTable reloadData];
}

- (void)setBackgroundImage 
{
	LOG_CURRENT_METHOD;
    
	UIImageView *customBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bkgnd.png"]];
	self.background = customBackground;
	[customBackground release];
	
	[self.view addSubview:background];
	LOG(@"Added background subview %@ to %@", background, self.view);
	[self.view sendSubviewToBack:background];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger i = [[IndigenousPortalVideoAppDelegate get].localVideoFeed count];
	LOG(@"Number of rows: %d",i);
    
	return i;
}

// Manages the height of the cell.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    // TODO: This code causes array crash!
    /*
    NSDictionary * s = [[iPortalAppDelegate get].localNewsFeed objectAtIndex:indexPath.row];
    cellString = [[s objectForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Default label size
    CGSize labelSize = CGSizeMake(273.0, 10.0);
    
    if ([cellString length] > 0) {
        //LOG(@"String length is greater than zero");
        
        // Scaled label size
        labelSize = [cellString sizeWithFont: [UIFont systemFontOfSize: 12.0] constrainedToSize: CGSizeMake(273.0, 1000.0) lineBreakMode: UILineBreakModeTailTruncation];
    }
    LOG(@"label height: %2f | %2f", labelSize.height, indexPath.row);
    
    return 149.0 + labelSize.height;
     */
    return 149.0;
} 

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	LOG(@"cellForRowAtIndexPath %@", indexPath);
    
	UITableViewCell *customCell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"VideoTableCell"];
    
	if (customCell == nil) 
    {
        [[NSBundle mainBundle] loadNibNamed:@"VideoTableCell" owner:self options:NULL];
		customCell = videoTableCell;
		LOG(@"customizing %@", customCell);
	} 
    else 
    { 
		LOG(@"reusing %@", customCell.reuseIdentifier);
	}

    LOG(@"Set cell content");
	UILabel* titleLabel = (UILabel*) [customCell viewWithTag:1];
	UILabel* contentLabel = (UILabel*) [customCell viewWithTag:3];
    
    int i = indexPath.row;
    NSDictionary * s = [[IndigenousPortalVideoAppDelegate get].localVideoFeed objectAtIndex:i];
    LOG(@"NS Dict: %@", s);
    
	titleLabel.text = [s objectForKey:@"title"];
    
    // Content
	// labelSize is hard-wired but could use constants to populate the size
	CGSize labelSize = CGSizeMake(182, 90);
	CGSize theStringSize = [[s objectForKey:@"description"] sizeWithFont:contentLabel.font constrainedToSize:labelSize lineBreakMode:contentLabel.lineBreakMode];
	contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, theStringSize.width, theStringSize.height);
    contentLabel.text = [s objectForKey:@"description"];

    // Image
    //This method works much faster then [NSData dataWithContentsOfURL
    // Also it works better on bad internet connections
    NSMutableURLRequest *requestWithBodyParams = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[s objectForKey:@"icon"]]];
    NSData *imageData = [NSURLConnection sendSynchronousRequest:requestWithBodyParams returningResponse:nil error:nil];
    UIImage *image = [UIImage imageWithData:imageData];
    
    // original
    /*
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[s objectForKey:@"icon"]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    */
    
    // from HitScan - http://www.hive05.com/2008/11/crop-an-image-using-the-iphone-sdk/
    CGRect rect = CGRectMake(0, 0, 90.0, 90.0);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    [videoIcon setImage:cropped];
    
    //[videoIcon setImage:image];
    //[imageData release]; original
    //[image release];
    
    // Odd / even
    UIView *myView = [[UIView alloc] init];
    if ((indexPath.row % 2) == 0) 
    {
        myView.backgroundColor = HEXCOLOR(0xEBEBEB33);
    } 
    else 
    {
        myView.backgroundColor = HEXCOLOR(0xFFFFFF66); //[UIColor whiteColor];
    }
    
    customCell.backgroundView = myView;
    [myView release];

    return customCell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    LOG_CURRENT_METHOD;
    LOG(@"row=%d, count=%d, list is%@ nil",indexPath.row,[[IndigenousPortalVideoAppDelegate get].localVideoFeed count],([IndigenousPortalVideoAppDelegate get].localVideoFeed==nil ? @"" : @" NOT"));
    
    [IndigenousPortalVideoAppDelegate playEffect:kEffectPage];
    NSDictionary * s = [[IndigenousPortalVideoAppDelegate get].localVideoFeed objectAtIndex:indexPath.row];
    [IndigenousPortalVideoAppDelegate get].cellURL = [s objectForKey:@"link"];   
    
    LOG(@"Cell %@ selected open link %@", indexPath, [IndigenousPortalVideoAppDelegate get].cellURL);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [IndigenousPortalVideoAppDelegate get].what = 2; // We set this so the HTML View knows where to return
    [self viewOnlineContent];
    
    // TODO: Replace with in app viewing. this opens mobile safari
    //NSURL *url = [[NSURL alloc] initWithString:[iPortalAppDelegate get].cellURL];
    //[[UIApplication sharedApplication] openURL:url];
}

- (void)setupView 
{
    LOG_CURRENT_METHOD;
    
#if __IPHONE_3_0
    // UIViewController slips up under status bar. We need to reset it to where it should be placed
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
#endif
    
    [self setBackgroundImage]; 
    [IndigenousPortalVideoAppDelegate get].what = 2;
    [[IndigenousPortalVideoAppDelegate get] checkFeed];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewOnlineContent 
{
    LOG_CURRENT_METHOD;
    
    HtmlViewController *thvc = [[HtmlViewController alloc] initWithNibName:@"HtmlView" bundle:nil];
    self.hvc = thvc;
    [thvc release];
    
    UIView *currentView = self.view;
	// get the the underlying UIWindow, or the view containing the current view view
	UIView *theWindow = [currentView superview];
	
	// remove the current view and replace with myView1
	[currentView removeFromSuperview];
    [theWindow addSubview:[hvc view]];
	
	// set up an animation for the transition between the views
	CATransition *animation = [CATransition animation];
	[animation setDuration:0.45];
	[animation setType:kCATransitionReveal];
	[animation setSubtype:kCATransitionFromRight];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[theWindow layer] addAnimation:animation forKey:@"swap"];    
}


@end

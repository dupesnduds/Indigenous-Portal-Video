//
//  AboutViewController.m
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 9/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import "AboutViewController.h"
#import "IndigenousPortalVideoAppDelegate.h"


@implementation AboutViewController

@synthesize delegate;
@synthesize background;
@synthesize webView;
@synthesize doneBtn;
@synthesize shareBtn;
@synthesize btnMtt;
@synthesize btnIp;


- (void)dealloc 
{
    if(webView) 
    {
        [webView release];
    }
    if(doneBtn) 
    {
        [doneBtn release];
    }    
    
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.webView.scalesPageToFit = NO;
    [webView setBackgroundColor:[UIColor clearColor]];
    
	[self setupController];
}

- (IBAction)done 
{   
    [IndigenousPortalVideoAppDelegate playEffect:kEffectButton];
    [IndigenousPortalVideoAppDelegate playEffect:kEffectPage];
	[self.delegate aboutViewControllerDidFinish:self];	
}

- (IBAction)mail {}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {}


- (void)setupController 
{
#if __IPHONE_3_0
    // UIViewController slips up under status bar. We need to reset it to where it should be placed
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
#endif
    
    [self loadAbout];    
    
    // Done button
    UIFont *displayFont = [UIFont fontWithName:@"Helvetica" size:14];
    doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 85.0f, 50.0f)];
#if __IPHONE_3_0
    doneBtn.titleLabel.font = displayFont;
#else
    doneBtn.font = displayFont;
#endif
    [doneBtn setBackgroundImage:[[UIImage imageNamed:@"share-163dpi.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [doneBtn setCenter:CGPointMake(50.0f, 54.0f)];
    [doneBtn setTitle:@" Done" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    [doneBtn setEnabled:YES];
    
    // IP
    btnIp = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 76.0f, 44.0f)];
    [btnIp setBackgroundImage:[[UIImage imageNamed:@"ip.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [btnIp setCenter:CGPointMake(160.0f, 54.0f)];    
    [btnIp addTarget:self action:@selector(loadAbout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnIp];
    [btnIp setEnabled:YES];
    
    // MTT
    btnMtt = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 76.0f, 44.0f)];
    [btnMtt setBackgroundImage:[[UIImage imageNamed:@"mtt.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [btnMtt setCenter:CGPointMake(267.0f, 54.0f)];    
    [btnMtt addTarget:self action:@selector(loadMtt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMtt];
    [btnMtt setEnabled:YES];
}

-(void)loadAbout
{    
    NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
    NSURL *helpURL = [NSURL fileURLWithPath:helpPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:helpURL]];
}

- (void)loadMtt 
{    
    NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"mtt" ofType:@"html" inDirectory:@"www"];
    NSURL *helpURL = [NSURL fileURLWithPath:helpPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:helpURL]];
}

-(void)loadNetworkError 
{
    LOG_CURRENT_METHOD;
    
    NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"network" ofType:@"html" inDirectory:@"www"];
    NSURL *helpURL = [NSURL fileURLWithPath:helpPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:helpURL]];
}


@end

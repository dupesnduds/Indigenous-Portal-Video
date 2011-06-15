//
//  IndigenousPortalVideoAppDelegate.m
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 14/06/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import "IndigenousPortalVideoAppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "NavViewController.h"
#import "CustomAlertViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SoundEngine.h"

#define kListenerDistance 1.0  // Used for creating a realistic sound field
#define ReachableViaWiFiNetwork 2
#define ReachableDirectWWAN (1 << 18)
/* 
 * Static members related to sound effects and background music 
 */
static BOOL fxEnabled = YES;			// Sound effects are enabled
static UInt32 sounds[kNumEffects];		// References to the loaded sound effects

@implementation IndigenousPortalVideoAppDelegate

@synthesize window;
@synthesize blankView;
@synthesize bvc;
@synthesize navViewController;
@synthesize cavc;
@synthesize localVideoFeed;
@synthesize cellURL;
@synthesize applicationActive;
@synthesize what, loadError;

+(IndigenousPortalVideoAppDelegate *) get 
{
    return (IndigenousPortalVideoAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)dealloc 
{
    if(cavc) 
    {
        [cavc release];
    }
    
    if(blankView) 
    {
        [blankView release];
    }
    
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
    [self setupApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)applicationWillResignActive:(UIApplication *)application 
{
	LOG(@"applicationWillResignActive");
    
	applicationActive = FALSE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
	LOG(@"applicationDidBecomeActive");
    
	applicationActive = TRUE;
}

#pragma mark -
#pragma mark iPortal

- (void)setupApp 
{
    LOG_CURRENT_METHOD;
    
    [self setupSound];
    [self setupViews];
}

- (void)setupViews 
{
    LOG_CURRENT_METHOD;
    
    UIViewController * tbvc = [[UIViewController alloc] init];
    self.bvc = tbvc;
    [tbvc release];
    
    //Use “bounds” instead of “applicationFrame” — the latter will introduce a 20 pixel empty status bar (unless you want that..)
    blankView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    bvc.view = blankView;
    blankView.backgroundColor = [UIColor clearColor];
    [window addSubview:blankView];    
    
    NavViewController * nvc = [[NavViewController alloc] initWithNibName:@"NavView" bundle:nil];
    self.navViewController = nvc;
    [nvc release];
    
    //Use “bounds” instead of “applicationFrame” — the latter will introduce a 20 pixel empty status bar (unless you want that..)
    self.navViewController.view.frame = [UIScreen mainScreen].applicationFrame;
    [self.bvc presentModalViewController:self.navViewController animated:YES];
    
    if(![self checkIsDataSourceAvailable]) 
    {
        CustomAlertViewController * tcavc = [[CustomAlertViewController alloc] initWithNibName:@"CustomAlertView" bundle:nil];
        self.cavc = tcavc;
        [tcavc release];
        
        //Use “bounds” instead of “applicationFrame” — the latter will introduce a 20 pixel empty status bar (unless you want that..)
        self.cavc.view.frame = [UIScreen mainScreen].applicationFrame;
        self.cavc.view.alpha = 0.0;
        [window addSubview:[cavc view]];
        
        [UIView beginAnimations:nil context:nil];  //Don't yell at me about not using NULL.  They're the same, it's just convention to use one for pointers and the other one for everything else.  
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.33];  //.25 looks nice as well.
        self.cavc.view.alpha = 1.0;
        [UIView commitAnimations];
    }
    
    [window makeKeyAndVisible];
    applicationActive = TRUE;
}

- (void)setupSound 
{
    LOG_CURRENT_METHOD;
    
    NSBundle* bundle = [NSBundle mainBundle];
    
    /*
	 * Initialize the audio engine
	 *
	 * Pilfered from the Apple Crash Landing example
	 */
	SoundEngine_Initialize(44100);									// Set the bitrate
	SoundEngine_SetListenerPosition(0.0, 0.0, kListenerDistance);	// Set the listener position
    SoundEngine_LoadEffect([[bundle pathForResource:@"button" ofType:@"caf"] UTF8String], &sounds[kEffectButton]);   
    SoundEngine_LoadEffect([[bundle pathForResource:@"instructions_trans" ofType:@"caf"] UTF8String], &sounds[kEffectPage]);   
}

- (void)checkFeed 
{
    LOG_CURRENT_METHOD;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.localVideoFeed = [NSMutableArray arrayWithArray:[prefs objectForKey:@"audiofeed"]];
    
    switch (self.what) 
    {
        case 2:
            if([self.localVideoFeed count] == 0) 
            {
                
                NSString * videoAddress = @"http://www.tumunu.com/";
                [self grabFeed:videoAddress];
            } else {
                
                LOG(@"Audio Feed: %2f", [localVideoFeed count]);
            }
            break;
        default:
            break;
    }
}

-(void) grabFeed:(NSString *)portalAddress 
{
    LOG_CURRENT_METHOD;
    
	localVideoFeed = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString: portalAddress];
    
    // Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
    // object that actually grabs and processes the RSS data
    CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    
    // Create a new Array object to be used with the looping of the results from the rssParser
    NSArray *resultNodes = NULL;
    
    // Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
    resultNodes = [rssParser nodesForXPath:@"//item" error:nil];
    
    // Loop through the resultNodes to access each items actual data
    for (CXMLElement *resultElement in resultNodes) 
    {
        NSMutableDictionary *newsItem = [[NSMutableDictionary alloc] init];
        
        // Create a counter variable as type "int"
        int counter;
        
        // Loop through the children of the current  node
        for(counter = 0; counter < [resultElement childCount]; counter++) 
        {
            [newsItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
        }
        
        switch (self.what) 
        {
            case 2:
                LOG(@"Video Array");
                LOG(@"Video Array - %@",[newsItem copy]);
                [localVideoFeed addObject:[newsItem copy]];
                break;
            default:
                break;
        }
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    switch (self.what)
    {
        case 2:
            LOG(@"Saving Video Array");
            [prefs setObject:localVideoFeed forKey:@"videofeed"];
            break;
        default:
            break;
    }
    [prefs synchronize];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)checkIsDataSourceAvailable 
{
    LOG_CURRENT_METHOD;
    
    static BOOL checkNetwork = YES;
    if (checkNetwork) {
        
        checkNetwork = NO;
        
        Boolean success;    
        const char *host_name = "tumunu.com";
        
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    
    return isDataSourceAvailable;
}

- (BOOL)checkIsDataSourceViaWifi 
{
    LOG_CURRENT_METHOD;
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef reachabilityRef;
    BOOL gotFlags;
    
    reachabilityRef = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(),[@"www.tumunu.com" UTF8String]);
    
    gotFlags = SCNetworkReachabilityGetFlags(reachabilityRef, &flags);
    CFRelease(reachabilityRef);
    
    if (!gotFlags) 
    {
        return NO;
    }
    
    if( flags & ReachableDirectWWAN ) 
    {
        return NO;
    }
    
    if( flags & ReachableViaWiFiNetwork ) 
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)springClean:(NSString *)sourceString 
{
    
    char charCode[28];
    int i;
    for(i=0x00;i<=0x08;i++) 
    {
        charCode[i]=i;
    }
    
    charCode[9]=0x0B;
    for(i=0x0E;i<=0x1F;i++) 
    {
        charCode[i]=i;
    }
    
    // get a scanner, initialised with our input string
    NSScanner *sourceScanner = [NSScanner scannerWithString:sourceString];
    // create a mutable output string (empty for now)
    NSMutableString *cleanedString = [[[NSMutableString alloc] init] autorelease];
    
    // create an array of chars for all control characters between 0×00 and 0×1F, apart from \t, \n, \f and \r (which are at code points 0×09, 0×0A, 0×0C and 0×0D respectively)
    
    // convert this array into an NSCharacterSet
    NSString *controlCharString = [NSString stringWithCString:charCode length:28];
    NSCharacterSet *controlCharSet = [NSCharacterSet characterSetWithCharactersInString:controlCharString];
    
    // request that the scanner ignores these characters
    [sourceScanner setCharactersToBeSkipped:controlCharSet];
    
    // run through the string to remove control characters
    while ([sourceScanner isAtEnd] == NO) 
    {
        NSString *outString;
        // scan up to the next instance of one of the control characters
        if ([sourceScanner scanUpToCharactersFromSet:controlCharSet intoString:&outString]) 
        {
            // add the string chunk to our output string
            [cleanedString appendString:outString];
        }
    }
    
    return cleanedString;
}


/*
 * The methods are all related to music and sound effects.  If you aren't going
 * to use any, you can safely remove these
 */
+ (void)setEffectsEnabled:(BOOL)enabled 
{
	fxEnabled = enabled;
}

+ (BOOL)isEffectsEnabled 
{
	return fxEnabled;
}

+ (void)playEffect:(Effect)effect 
{
	if(!fxEnabled) return;
	SoundEngine_StartEffect(sounds[effect]);
}


@end


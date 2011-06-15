

#import "ActivityIndicator.h"



@implementation ActivityIndicator

@synthesize window;

static ActivityIndicator *activityIndicator;

- (id) init
{
	self = [super init];
	if (self != nil) 
    {
		[[NSBundle mainBundle] loadNibNamed:@"ActivityIndicator" owner:self options:nil];
	}
	return self;
}

+ (ActivityIndicator *)sharedActivityIndicator 
{
    
	if (!activityIndicator)
	{	
		activityIndicator = [[ActivityIndicator alloc] init];
		activityIndicator.window.windowLevel = UIWindowLevelAlert;
	}
	
	return activityIndicator;
}

- (void)show 
{
	[window makeKeyAndVisible];
	window.hidden = NO;
}

- (void)hide 
{
	[window resignKeyWindow];
	window.hidden = YES;
}


@end

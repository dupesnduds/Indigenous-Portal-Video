

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ActivityIndicator : NSObject 
{
    IBOutlet UIWindow *window;
}

@property (nonatomic, readonly) UIWindow *window;
+ (ActivityIndicator *)sharedActivityIndicator;

- (void)show;
- (void)hide;


@end

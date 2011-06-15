//
//  IndigenousPortalAppDelegate.h
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 14/06/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TouchXML.h"


/*
 * Sound effect enum.  
 *
 * Pass in one of these to playEffect: to
 * play the cached sound effect.  Sound effects are all loaded
 * during initialization.
 */
typedef enum {
    kEffectButton=0,
    kEffectPage,
	kNumEffects
} Effect;


@class NavViewController;
@class CustomAlertViewController;


@interface IndigenousPortalVideoAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    UIView * blankView;
    UIViewController * bvc;
    
    NavViewController * navViewController;
    CustomAlertViewController * cavc;
    
    NSMutableArray * localVideoFeed;
    
    BOOL applicationActive;
    BOOL isDataSourceAvailable;
    
    BOOL shouldYouLoadIndicator;
    
    NSString * cellURL;
    int what;   
    int loadError;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIView * blankView;
@property (nonatomic, retain) UIViewController * bvc;
@property (nonatomic, retain) NavViewController * navViewController;
@property (nonatomic, retain) CustomAlertViewController * cavc;
@property (nonatomic, retain) NSMutableArray * localVideoFeed;
@property (nonatomic, retain) NSString * cellURL;
@property (readonly) BOOL applicationActive;
@property (nonatomic) int what;
@property (nonatomic) int loadError;

- (void)setupApp;
- (void)setupViews;
- (void)setupSound;
- (void)checkFeed;
- (void)grabFeed:(NSString *)portalAddress;
- (BOOL)checkIsDataSourceAvailable;
- (BOOL)checkIsDataSourceViaWifi;


/* 
 * Sound effect methods
 */
+ (void)setEffectsEnabled:(BOOL)enabled;
+ (void)playEffect:(Effect)effect;
+ (BOOL)isEffectsEnabled;

+(IndigenousPortalVideoAppDelegate *) get;


@end


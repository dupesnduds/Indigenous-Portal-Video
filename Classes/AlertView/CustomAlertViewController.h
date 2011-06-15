//
//  CustomAlertView.h
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 17/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CustomAlertViewController : UIViewController <UIWebViewDelegate> 
{
    IBOutlet UIWebView * webView;
    UIImageView * background;
}


@property (nonatomic, retain) IBOutlet UIWebView * webView;
@property (nonatomic, retain) UIImageView * background;

- (IBAction)closeAlert;
- (void)setupView;
- (void)setBackgroundImage;
- (void)loadNetworkError;
- (void)loadWifiError;


@end

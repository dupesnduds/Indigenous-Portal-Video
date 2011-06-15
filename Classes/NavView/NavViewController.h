//
//  NavViewController.h
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 14/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import <UIKit/UIKit.h>


@class VideoViewController;


@interface NavViewController : UIViewController {

    UIImageView *background;
    VideoViewController * avc;
    int what;
}


@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) VideoViewController * avc;
@property (nonatomic) int what;

- (IBAction)showVideoList;
- (void)setBackgroundImage;
- (void)switchView;


@end

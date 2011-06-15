//
//  VideoViewController.h
//  Indigenous Portal Video
//
//  Created by Cleave Pokotea on 14/05/09.
//  Copyright Tumunu 2009 - 2011. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AboutViewController.h"

@class HtmlViewController;


@interface VideoViewController : UIViewController <AboutViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> 
{
    UIImageView * background;
    NSString * cellString;
    UITableView * videoTable;
    UITableViewCell * videoTableCell;
    UIImageView * videoIcon;
    
    HtmlViewController * hvc;    
    int what;
}


@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) NSString * cellString;
@property (nonatomic, retain) IBOutlet UITableView * videoTable;
@property (nonatomic, retain) IBOutlet UITableViewCell * videoTableCell;
@property (nonatomic, retain) IBOutlet UIImageView * videoIcon;
@property (nonatomic, retain) HtmlViewController * hvc;
@property (nonatomic) int what;

- (IBAction)showAbout;
- (IBAction)refreshList;
- (void)setupView;
- (void)setBackgroundImage;
- (void)viewOnlineContent;


@end

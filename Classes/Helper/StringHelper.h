//
//  StringHelper.h
//  PTLog
//
//  Created by Ellen Miner on 1/2/09.
//  Copyright 2009 RaddOnline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (StringHelper)
- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size;
- (UILabel *)RAD_sizeCellLabelWithSystemFontOfSize:(CGFloat)size;
@end


//
//  TRBusinessTitleBox.m
//  TheRiverApp
//
//  Created by DenisDbv on 08.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRBusinessTitleBox.h"

@implementation TRBusinessTitleBox

- (void)setup {
    
    self.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
}

+(TRBusinessTitleBox *)initBox:(CGSize)bounds withUserData:(TRUserInfoModel *)userObject
{
    TRBusinessTitleBox *box = [TRBusinessTitleBox boxWithSize: CGSizeMake(bounds.width, 41)];
    box.userData = userObject;
    
    [box showTitleLabel];
    
    return box;
}

-(void) showTitleLabel
{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Black" size:18];
    nameLabel.numberOfLines = 1;
    nameLabel.text = @"Бизнесы";
    
    CGSize size = [nameLabel.text sizeWithFont:nameLabel.font constrainedToSize:CGSizeMake(150.0, FLT_MAX) lineBreakMode:nameLabel.lineBreakMode ];
    nameLabel.frame = CGRectMake(12.0, 15.0, size.width, size.height);
    
    [self addSubview: nameLabel];
}

@end

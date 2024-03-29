//
//  TRBusinessTitleBox.m
//  TheRiverApp
//
//  Created by DenisDbv on 10.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRBusinessUnitTitleBox.h"
#import <MGBox2/MGLineStyled.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "TRUserProfileController.h"

@implementation TRBusinessUnitTitleBox

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftMargin = self.rightMargin = 9;
}

+(TRBusinessUnitTitleBox *)initBox:(CGSize)bounds withMindData:(TRBusinessModel *)businessObject
{
    TRBusinessUnitTitleBox *box = [TRBusinessUnitTitleBox boxWithSize: CGSizeMake(bounds.width, 10)];
    box.businessData = businessObject;
    
    box.contentLayoutMode = MGLayoutTableStyle;
    
    /*MGLineStyled *dateCreateLine = [MGLineStyled lineWithLeft:nil multilineRight:businessObject.businessDate width:300.0 minHeight:10.0];
    dateCreateLine.backgroundColor = [UIColor clearColor];
    dateCreateLine.topMargin = 10;
    dateCreateLine.rightPadding = 0;
    dateCreateLine.borderStyle = MGBorderNone;
    dateCreateLine.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    [box.boxes addObject:dateCreateLine];*/
    
    UIImageView *userLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightbar_contact_placeholder.png"]];
    userLogo.frame = CGRectMake(3, 8, 25, 25);
    userLogo.layer.borderWidth = 0;
    userLogo.layer.borderColor = [UIColor whiteColor].CGColor;
    userLogo.layer.cornerRadius = CGRectGetHeight(userLogo.bounds) / 2;
    userLogo.clipsToBounds = YES;
    [box addSubview:userLogo];
    
    if(businessObject.user_logo.length != 0) {
        NSString *logoURLString = [SERVER_HOSTNAME stringByAppendingString:businessObject.user_logo];
        
        UIImage *imgLogoCellFromDisk = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:logoURLString];
        if(imgLogoCellFromDisk == nil) {
            [userLogo setImageWithURL:[NSURL URLWithString:logoURLString] placeholderImage:[UIImage imageNamed:@"rightbar_contact_placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if(image != nil)
                {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:logoURLString toDisk:YES];
                }
            }];
        } else  {
            [userLogo setImage:imgLogoCellFromDisk];
        }
    } else    {
        [userLogo setImage:[UIImage imageNamed:@"rightbar_contact_placeholder.png"]];
    }
    
    NSString *fullTitle = [NSString stringWithFormat:@"%@ %@ %@ %@, %@", businessObject.first_name, businessObject.last_name, businessObject.age, [box getStringYearByAge:[businessObject.age integerValue]], businessObject.city];
    MGLineStyled *authorLine = [MGLineStyled lineWithLeft:fullTitle multilineRight:nil width:300-35 minHeight:10];
    authorLine.backgroundColor = [UIColor clearColor];
    authorLine.topMargin = 12;
    authorLine.leftPadding = authorLine.rightPadding = 0;
    authorLine.leftMargin = 35;
    authorLine.borderStyle = MGBorderNone;
    authorLine.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [box.boxes addObject:authorLine];
    
    MGLineStyled *titleLine = [MGLineStyled lineWithMultilineLeft:businessObject.company_name right:nil width:300.0 minHeight:10];
    titleLine.backgroundColor = [UIColor clearColor];
    titleLine.topMargin = 20;
    titleLine.leftPadding = titleLine.rightPadding = 0;
    titleLine.borderStyle = MGBorderNone;
    titleLine.font = [UIFont fontWithName:@"HypatiaSansPro-Bold" size:23];
    [box.boxes addObject:titleLine];
    
    MGLineStyled *aboutLine = [MGLineStyled lineWithMultilineLeft:businessObject.about right:nil width:300 minHeight:10];
    aboutLine.backgroundColor = [UIColor clearColor];
    aboutLine.topMargin = 0;
    aboutLine.leftPadding = authorLine.rightPadding = 0;
    aboutLine.borderStyle = MGBorderNone;
    aboutLine.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [box.boxes addObject:aboutLine];
    
    if(businessObject.url.length > 0)    {
        NSString *urlString = [businessObject.url stringByReplacingOccurrencesOfString:@"http://"
                                                                           withString:@""
                                                                              options:NSAnchoredSearch // beginning of string
                                                                                range:NSMakeRange(0, [businessObject.url length])];
        //NSLog(@"=>%@", urlString);
        NSString *businessLinkStr = [NSString stringWithFormat:@"__%@__ |mush", urlString];
        MGLineStyled *businessLink = [MGLineStyled lineWithMultilineLeft:businessLinkStr right:nil width:300 minHeight:10];
        businessLink.backgroundColor = [UIColor clearColor];
        businessLink.topMargin = 5;
        businessLink.leftPadding = businessLink.rightPadding = 0;
        businessLink.borderStyle = MGBorderNone;
        businessLink.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        businessLink.textColor = [UIColor colorWithRed:46.0/255.0 green:64.0/255.0 blue:197.0/255.0 alpha:1.0];
        [box.boxes addObject:businessLink];
        
        businessLink.onTap = ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:businessObject.url]];
        };
    }
    
    MGLineStyled *blocksLine = [MGLineStyled lineWithLeft:[box blockWithTitle:@"Оборот в месяц" andText:[NSString stringWithFormat:@"%@ р", businessObject.profit]]
                                                    right:[box blockWithTitle:@"Количество сотрудников" andText:businessObject.employees]
                                                     size:CGSizeMake(300, 60)];
    blocksLine.backgroundColor = [UIColor clearColor];
    blocksLine.topMargin = 10;
    blocksLine.leftPadding = 0;
    blocksLine.rightPadding = 0;
    blocksLine.borderStyle = MGBorderNone;
    [box.boxes addObject:blocksLine];
    
    return box;
}

-(NSString*) getStringYearByAge:(NSInteger)age
{
    NSInteger lastDigit = age % 10;
    
    //NSLog(@"==>%i", lastDigit);
    
    if( lastDigit == 1 )
        return @"год";
    else if( lastDigit > 1 && lastDigit <= 4 )
        return @"года";
    else if( (lastDigit >= 5 && lastDigit <= 9) || lastDigit == 0 )
        return @"лет";
    
    return @"";
}

-(UIView*) blockWithTitle:(NSString*)title andText:(NSString*)text
{
    UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140.0, 50.0)];
    blockView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"HypatiaSansPro-Regular" size:12.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = title;
    titleLabel.frame = CGRectMake(0, 5, blockView.bounds.size.width, 14);
    [blockView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont fontWithName:@"HypatiaSansPro-Bold" size:20.0];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor grayColor];
    textLabel.text = text;
    textLabel.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, blockView.bounds.size.width, 30);
    [blockView addSubview:textLabel];
    
    return blockView;
}

@end

//
//  TRMeetingItemCell.m
//  TheRiverApp
//
//  Created by DenisDbv on 13.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRMeetingItemCell.h"

@implementation TRMeetingItemCell
{
    TREventModel *eventItem;
}
@synthesize labelCity, labelDay, labelGroup, labelMonth, labelTitle, agreeButton, labelIfDisable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialized];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initialized];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) initialized
{
    labelDay.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    labelMonth.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    labelCity.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    labelTitle.font = [UIFont fontWithName:@"HypatiaSansPro-Bold" size:18];
    labelGroup.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    labelIfDisable.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
}

-(void) reloadWithMeetingModel:(TREventModel*)meetingObject
{
    eventItem = meetingObject;
    
    labelDay.textColor = labelMonth.textColor = [UIColor redColor];
    labelCity.textColor = [UIColor lightGrayColor];
    labelTitle.textColor = labelGroup.textColor = labelIfDisable.textColor = [UIColor blackColor];
    
    if(meetingObject.isEnded == YES)
    {
        labelDay.textColor = labelCity.textColor = labelGroup.textColor = labelMonth.textColor = labelTitle.textColor = labelIfDisable.textColor = [UIColor lightGrayColor];
    }

    NSInteger maxDateBlock = 80.0; //[self getMaxWidthFromStrings:meetingObject];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSDate *myDate = [df dateFromString: meetingObject.start_date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    [self changeSizeLabel:labelDay atString:[dateFormatter stringFromDate:myDate]];
    labelDay.frame = [self changeWidthInFrame:labelDay.frame byWidth:maxDateBlock];
    labelDay.frame = [self changeXInFrame:labelDay.frame byX:10];
    
    [dateFormatter setDateFormat:@"MMMM"];
    [self changeSizeLabel:labelMonth atString:[dateFormatter stringFromDate:myDate]];
    labelMonth.frame = [self changeWidthInFrame:labelMonth.frame byWidth:maxDateBlock];
    labelMonth.frame = [self changeYInFrame:labelMonth.frame byY:labelDay.frame.origin.y+labelDay.frame.size.height+3];
    labelMonth.frame = [self changeXInFrame:labelMonth.frame byX:10];
    
    [self changeSizeLabel:labelCity atString:meetingObject.place];
    labelCity.frame = [self changeWidthInFrame:labelCity.frame byWidth:maxDateBlock];
    labelCity.frame = [self changeYInFrame:labelCity.frame byY:labelMonth.frame.origin.y+labelMonth.frame.size.height+5];
    labelCity.frame = [self changeXInFrame:labelCity.frame byX:10];
    //labelCity.backgroundColor = [UIColor yellowColor];
    
    NSInteger xOffset = (maxDateBlock+10)+15;
    NSInteger secondWidth = 320-xOffset-10;
    CGSize sizeTitle = [meetingObject.title sizeWithFont:labelTitle.font
                                            constrainedToSize:CGSizeMake(secondWidth, 50)
                                                lineBreakMode:NSLineBreakByWordWrapping];
    labelTitle.text = meetingObject.title;
    labelTitle.frame = CGRectMake(xOffset, 10, secondWidth, sizeTitle.height);
    //labelTitle.backgroundColor = [UIColor redColor];
    
    CGSize sizeGroup = [meetingObject.group sizeWithFont:labelGroup.font
                                              constrainedToSize:CGSizeMake(secondWidth, 50)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
    labelGroup.text = meetingObject.group;
    labelGroup.frame = CGRectMake(xOffset, labelTitle.frame.origin.y+labelTitle.frame.size.height, secondWidth, sizeGroup.height);
    
    if(meetingObject.isEnded == NO)    {
        labelIfDisable.hidden = YES;
        agreeButton.hidden = NO;
        
        agreeButton.frame = CGRectMake(xOffset, labelGroup.frame.origin.y+labelGroup.frame.size.height+10, 125, 35);
        [agreeButton addTarget:self action:@selector(onSbscrClick:) forControlEvents:UIControlEventTouchUpInside];
        [agreeButton setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] disableColor:nil];
        [agreeButton setCornerRadius:4];
        [agreeButton setBorderStyle:nil andInnerColor:nil];
        
        if(meetingObject.isAccept == NO) {
            [agreeButton setStyle:[UIColor colorWithRed:77.0/255.0 green:112.0/255.0 blue:255.0/255.0 alpha:1.0] andBottomColor:[UIColor colorWithRed:77.0/255.0 green:112.0/255.0 blue:255.0/255.0 alpha:1.0]];
            [agreeButton setLabelTextShadow:CGSizeMake(0.5, 1) normalColor:nil highlightedColor:[UIColor blueColor] disableColor:nil];
            [agreeButton setTitle:@"Я пойду" forState:UIControlStateNormal];
            [agreeButton setImage:[UIImage new] forState:UIControlStateNormal];
            [agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        } else  {
            [agreeButton setStyle:[UIColor colorWithRed:110.0/255.0 green:206.0/255.0 blue:15.0/255.0 alpha:1.0] andBottomColor:[UIColor colorWithRed:110.0/255.0 green:206.0/255.0 blue:15.0/255.0 alpha:1.0]];
            [agreeButton setLabelTextShadow:CGSizeMake(0.5, 1) normalColor:nil highlightedColor:[UIColor greenColor] disableColor:nil];
            [agreeButton setTitle:@"Я иду" forState:UIControlStateNormal];
            [agreeButton setImage:[UIImage imageNamed:@"check-icon-white@2x.png"] forState:UIControlStateNormal];
            [agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        }
    } else  {
        agreeButton.hidden = YES;
        labelIfDisable.hidden = NO;
        
        CGSize sizeGroup = [@"Мероприятие окончено" sizeWithFont:labelIfDisable.font
                                                  constrainedToSize:CGSizeMake(secondWidth, 50)
                                                      lineBreakMode:NSLineBreakByWordWrapping];
        labelIfDisable.text = @"Мероприятие окончено";
        
        if(labelTitle.frame.size.height > 25)
            labelIfDisable.frame = CGRectMake(xOffset, labelGroup.frame.origin.y+labelGroup.frame.size.height+10, secondWidth, sizeGroup.height);
        else
            labelIfDisable.frame = CGRectMake(xOffset, labelCity.frame.origin.y + roundf((labelCity.frame.size.height-sizeGroup.height)/2), secondWidth, sizeGroup.height);
    }
}

-(CGFloat) getCellHeight:(TREventModel*)meetingObject
{
    NSInteger maxDateBlock = 80.0;
    NSInteger xOffset = (maxDateBlock+10)+15;
    NSInteger secondWidth = 320-xOffset-10;
    
    CGSize sizeTitle = [meetingObject.title sizeWithFont:[UIFont fontWithName:@"HypatiaSansPro-Bold" size:18]
                                       constrainedToSize:CGSizeMake(secondWidth, 50)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize sizeGroup = [meetingObject.group sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]
                                       constrainedToSize:CGSizeMake(secondWidth, 50)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger deltaHeight = 0;
    
    if(meetingObject.isEnded == NO) {
        deltaHeight = 35;
    } else  {
        CGSize sizeEnded = [@"Мероприятие окончено" sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]
                                               constrainedToSize:CGSizeMake(secondWidth, 50)
                                                   lineBreakMode:NSLineBreakByWordWrapping];
        if(sizeTitle.height > 25)   {
            deltaHeight = sizeEnded.height;
        } else  {
            return 10 + 30 + 3 + 15 + 5 + 15 + 10 + 10;
        }
    }
    
    return 10 + sizeTitle.height + sizeGroup.height + 10 + deltaHeight + 10;
}

-(void) onSbscrClick:(id)sender
{
    agreeButton.enabled = NO;
    agreeButton.userInteractionEnabled = NO;
    
    [[TRMeetingManager client] subscribeMeetingByID:eventItem.objectId successOperation:^(LRRestyResponse *response) {
        if(eventItem.isAccept == NO)
        {
            eventItem.isAccept = YES;
            
            [agreeButton setStyle:[UIColor colorWithRed:110.0/255.0 green:206.0/255.0 blue:15.0/255.0 alpha:1.0] andBottomColor:[UIColor colorWithRed:110.0/255.0 green:206.0/255.0 blue:15.0/255.0 alpha:1.0]];
            [agreeButton setLabelTextShadow:CGSizeMake(0.5, 1) normalColor:nil highlightedColor:[UIColor greenColor] disableColor:nil];
            [agreeButton setTitle:@"Я иду" forState:UIControlStateNormal];
            [agreeButton setImage:[UIImage imageNamed:@"check-icon-white@2x.png"] forState:UIControlStateNormal];
            [agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        } else  {
            eventItem.isAccept = NO;
            
            [agreeButton setStyle:[UIColor colorWithRed:77.0/255.0 green:112.0/255.0 blue:255.0/255.0 alpha:1.0] andBottomColor:[UIColor colorWithRed:77.0/255.0 green:112.0/255.0 blue:255.0/255.0 alpha:1.0]];
            [agreeButton setLabelTextShadow:CGSizeMake(0.5, 1) normalColor:nil highlightedColor:[UIColor blueColor] disableColor:nil];
            [agreeButton setTitle:@"Я пойду" forState:UIControlStateNormal];
            [agreeButton setImage:[UIImage new] forState:UIControlStateNormal];
            [agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        agreeButton.enabled = YES;
        agreeButton.userInteractionEnabled = YES;
        [agreeButton layoutSubviews];
    } andFailedOperation:^(LRRestyResponse *response) {
        agreeButton.enabled = YES;
        agreeButton.userInteractionEnabled = YES;
    }];
}

-(NSInteger) getMaxWidthFromStrings:(TREventModel*)meetingObject
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSDate *myDate = [df dateFromString: meetingObject.start_date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    
    CGSize sizeMonth = [[dateFormatter stringFromDate:myDate] sizeWithFont:labelMonth.font
                          constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)
                              lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeCity = [meetingObject.place sizeWithFont:labelCity.font
                                              constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    return MAX(sizeMonth.width, sizeCity.width);
}

-(void) changeSizeLabel:(UILabel*)label atString:(NSString*)text
{
    CGSize size = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.text = text;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height);
}

-(CGRect) changeWidthInFrame:(CGRect)frame byWidth:(NSInteger)width
{
    return CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

-(CGRect) changeYInFrame:(CGRect)frame byY:(NSInteger)coord
{
    return CGRectMake(frame.origin.x, coord, frame.size.width, frame.size.height);
}

-(CGRect) changeXInFrame:(CGRect)frame byX:(NSInteger)coord
{
    return CGRectMake(coord, frame.origin.y, frame.size.width, frame.size.height);
}

-(UITableView*) getTableView:(UIView*)theView
{
    if (!theView.superview)
        return nil;
    
    if ([theView.superview isKindOfClass:[UITableView class]])
        return (UITableView*)theView.superview;
    
    return [self getTableView:theView.superview];
}

-(void) updateCell
{
    UITableView *table = [self getTableView:self.contentView];
    if(table != nil)    {
        NSIndexPath *indexPath = [table indexPathForCell:self];
        [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end

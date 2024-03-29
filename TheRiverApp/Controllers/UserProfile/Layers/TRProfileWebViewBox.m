//
//  TRProfileWebViewBox.m
//  TheRiverApp
//
//  Created by DenisDbv on 01.10.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRProfileWebViewBox.h"

#import <SSToolkit/SSToolkit.h>
#import <MGBox2/MGScrollView.h>
#import "TRMindRatingBox.h"

#import "WDActivityIndicator.h"

@interface TRProfileWebViewBox()
@property (nonatomic, retain) SSWebView *webView;
@property (nonatomic, retain) WDActivityIndicator *activityIndicator;
@end

@implementation TRProfileWebViewBox

- (void)setup {
    
    self.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    
    self.leftMargin = self.rightMargin = 0;
    self.topMargin = 0;
    
    //self.topBorderColor = [UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0];
}

+(TRProfileWebViewBox *) initBox:(CGSize)bounds withUserData:(TRUserInfoModel*)userObject;
{
    TRProfileWebViewBox *box = [TRProfileWebViewBox boxWithSize: CGSizeMake(bounds.width, 100)];
    box.userData = userObject;
    
    box.webView = [[SSWebView alloc] initWithFrame:CGRectMake(5, 0, bounds.width-10, 1)];
    [box addSubview: box.webView];
    
    box.webView.alpha = 0.0f;
    box.webView.scrollView.scrollEnabled = NO;
    box.webView.delegate = box;
    box.webView.scalesPageToFit = NO;
    box.webView.backgroundColor = [UIColor clearColor];
    box.webView.scrollView.backgroundColor = [UIColor clearColor];
    [box.webView loadHTMLString:box.userData.business.desc];
    //[box.webView loadURLString:box.businessData.businessURL];
    
    box.activityIndicator = [[WDActivityIndicator alloc] initWithFrame:CGRectMake(box.bounds.size.width/2-21/2, box.bounds.size.height/2-21/2, 0, 0)];
    [box.activityIndicator setIndicatorStyle:WDActivityIndicatorStyleGradient];
    [box.activityIndicator startAnimating];
    [box addSubview:box.activityIndicator];
    
    return box;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.webView.loading == NO)  {
        [self.activityIndicator stopAnimating];
        
        NSInteger webContentHeight = self.webView.scrollView.contentSize.height;
        
        self.height = webContentHeight;
        self.webView.size = CGSizeMake(self.webView.bounds.size.width, self.height-1);
        [self refreshRootSize];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            //self.borderStyle = MGBorderEtchedBottom;
            //[self showMindRating];
        }];
    }
}

-(void) refreshRootSize
{
    MGScrollView *scroll = (MGScrollView*)self.parentBox;
    [scroll layoutWithSpeed:0.3 completion:nil];
}

@end

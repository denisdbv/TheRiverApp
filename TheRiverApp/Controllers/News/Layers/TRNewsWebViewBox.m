//
//  TRBusinessWebViewBox.m
//  TheRiverApp
//
//  Created by DenisDbv on 10.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRNewsWebViewBox.h"

#import <SSToolkit/SSToolkit.h>
#import <MGBox2/MGScrollView.h>
#import "TRMindRatingBox.h"

#import "WDActivityIndicator.h"

@interface TRNewsWebViewBox()
@property (nonatomic, retain) SSWebView *webView;
@property (nonatomic, retain) WDActivityIndicator *activityIndicator;
@end

@implementation TRNewsWebViewBox

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.leftMargin = self.rightMargin = 0;
    
    //self.topBorderColor = [UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0];
}

+(TRNewsWebViewBox *)initBox:(CGSize)bounds withNewsData:(TRNewsItem *)newsItem
{
    TRNewsWebViewBox *box = [TRNewsWebViewBox boxWithSize: CGSizeMake(bounds.width, 100)];
    box.newsItem = newsItem;
    //box.backgroundColor = [UIColor redColor];
    
    box.webView = [[SSWebView alloc] initWithFrame:CGRectMake(0, 0, bounds.width, 1)];
    [box addSubview: box.webView];
    
    box.webView.alpha = 0.0f;
    box.webView.scrollView.scrollEnabled = NO;
    box.webView.delegate = box;
    box.webView.scalesPageToFit = NO;
    box.webView.backgroundColor = [UIColor clearColor];
    box.webView.scrollView.backgroundColor = [UIColor clearColor];
    
    [box.webView loadHTMLString:newsItem.text];
    
    return box;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.webView.loading == NO)  {
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

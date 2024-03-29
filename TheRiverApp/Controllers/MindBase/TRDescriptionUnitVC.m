//
//  TRDescriptionUnitVC.m
//  TheRiverApp
//
//  Created by DenisDbv on 08.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRDescriptionUnitVC.h"
#import "MFSideMenu.h"

#import <MGBox2/MGBox.h>
#import <MGBox2/MGScrollView.h>
#import <MGBox2/MGTableBoxStyled.h>
#import <MGBox2/MGLineStyled.h>

#import "TRMindLogoBox.h"
#import "TRMindTitleBox.h"
#import "TRMindWebViewBox.h"

@interface UIBarButtonItem (BarButtonItemExtended)
+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;
@end

@implementation UIBarButtonItem (BarButtonItemExtended)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action
{
    UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton setImage:image forState:UIControlStateNormal];
    imgButton.frame = CGRectMake(0.0, 0.0, image.size.width/2, image.size.height/2);
    
    UIBarButtonItem *b = [[UIBarButtonItem alloc]initWithCustomView:imgButton];
    
    [imgButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [b setAction:action];
    [b setTarget:target];
    
    return b;
}
@end

@interface TRDescriptionUnitVC ()
@property (nonatomic, retain) MGScrollView *scrollView;
@property (nonatomic, retain) TRMindModel *mindDataObject;
@end

@implementation TRDescriptionUnitVC

-(id) initByMindModel:(TRMindModel*)mindObject
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _mindDataObject = mindObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    [self addSwipeGestureRecognizer];
    
    UIBarButtonItem *onCancelButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"toolbar-back-button@2x.png"] target:self action:@selector(onBack)];
    [onCancelButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:onCancelButton animated:YES];
    
    [self createRootScrollView];
    
    [self showMindLogo];
    [self showMindTitle];
    [self showMindWebView];
    
    [_scrollView layoutWithSpeed:0.3 completion:nil];
    
    NSLog(@"#####");
}

-(void) onBack
{
    NSLog(@"1111");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    
    if(event == MFSideMenuStateEventMenuDragBegin)
    {
        _scrollView.scrollEnabled = NO;
    }
    else if(event == MFSideMenuStateEventMenuDragEnd)
    {
        _scrollView.scrollEnabled = YES;
    }
}

#pragma mark - Swipe gesture

- (void)addSwipeGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded &&
        gestureRecognizer.direction & UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Create data views for controller

-(void) createRootScrollView
{
    _scrollView = [[MGScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _scrollView.padding = UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0);
    [self.view addSubview:_scrollView];
}

-(void) showMindLogo
{
    TRMindLogoBox *logoBox = (TRMindLogoBox*)[TRMindLogoBox initBox: CGSizeMake(300, 0)
                                           withMindData:_mindDataObject];
    [_scrollView.boxes addObject: logoBox];
}

-(void) showMindTitle
{
    TRMindTitleBox *titleBox = (TRMindTitleBox*)[TRMindTitleBox initBox: CGSizeMake(300, 0)
                                                       withMindData:_mindDataObject];
    [_scrollView.boxes addObject: titleBox];
}

-(void) showMindWebView
{
    TRMindWebViewBox *webViewBox = (TRMindWebViewBox*)[TRMindWebViewBox initBox: CGSizeMake(320, 0)
                                                           withMindData:_mindDataObject];
    [_scrollView.boxes addObject: webViewBox];
}

@end

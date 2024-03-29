//
//  TRImageViewController.m
//  TheRiverApp
//
//  Created by DenisDbv on 07.09.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "TRImageViewController.h"
#import "MFSideMenu.h"
#import "ZoomView.h"
#import "UIBarButtonItem+BarButtonItemExtended.h"

@interface TRImageViewController ()
@property (nonatomic, retain) ZoomView *zoomView;
@end

@implementation TRImageViewController
{
    NSString *_imageName;
}

-(id) initWithImage:(NSString*)imageName
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _imageName = imageName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *onCancelButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"toolbar-back-button@2x.png"] target:self action:@selector(onBack)];
    [onCancelButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:onCancelButton animated:YES];
	
    [self initialized];
    
    [self addSwipeGestureRecognizer];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initialized
{
    _zoomView = [[ZoomView alloc] initWithFrame: self.view.bounds];
    _zoomView.backgroundColor = [UIColor blackColor];
    _zoomView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_zoomView setImage:[UIImage imageNamed:_imageName]];
    [self.view addSubview:_zoomView];
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

@end

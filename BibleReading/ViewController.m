//
//  ViewController.m
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
        UIButton *listBtn;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *profileView;
@property UIView *photoView;
@property UIView *MovieView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self createProfileView];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)viewListMenu:(id)sender{
    NSArray *images = @[
                        [UIImage imageNamed:@"profile_tk.png"],
                        [UIImage imageNamed:@"image_tk.png"],
                        [UIImage imageNamed:@"video_tk.png"],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    [callout show];
}

- (void)createProfileView{
    _profileView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_profileView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_profileView addSubview:listBtn];
    
    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.10 green:0.84 blue:0.99 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.11 green:0.30 blue:0.94 alpha:1.0].CGColor, nil];
    [_profileView.layer insertSublayer:pageGradient atIndex:0];
     
    NSLog(@"1枚目");
}


- (void)createPhotoView{
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_photoView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:listBtn];
    
    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.99 green:0.76 blue:0.46 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:1.0 green:0.55 blue:0.0 alpha:1.0].CGColor, nil];
    [_photoView.layer insertSublayer:pageGradient atIndex:0];
    NSLog(@"2枚目");
}


- (void)createMovieView{
    _MovieView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_MovieView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_MovieView addSubview:listBtn];
    

    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.64 green:0.91 blue:0.53 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.35 green:0.83 blue:0.15 alpha:1.0].CGColor, nil];
    [_MovieView.layer insertSublayer:pageGradient atIndex:0];
    NSLog(@"3枚目");
}


- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            if (![_profileView isDescendantOfView:self.view]) {
                NSLog(@"pp");
                [self createProfileView];
            }
            if (_profileView.hidden) {
                _profileView.hidden = NO;
            }
            [self.view bringSubviewToFront:_profileView];
            if ([_photoView isDescendantOfView:self.view]) {
                _photoView.hidden = YES;
            }
            if ([_MovieView isDescendantOfView:self.view]) {
                _MovieView.hidden = YES;
            }
            break;
        case 1:
            if (![_photoView isDescendantOfView:self.view]) {
                [self createPhotoView];
            }
            if (_photoView.hidden) {
                _photoView.hidden = NO;
            }
            [self.view bringSubviewToFront:_photoView];
            if ([_profileView isDescendantOfView:self.view]) {
                _profileView.hidden = YES;
            }
            if ([_MovieView isDescendantOfView:self.view]) {
                _MovieView.hidden = YES;
            }
            break;
        case 2:
            if (![_MovieView isDescendantOfView:self.view]) {
                [self createMovieView];
            }
            if (_MovieView.hidden) {
                _MovieView.hidden = NO;
            }
            if ([_profileView isDescendantOfView:self.view]) {
                _photoView.hidden = YES;
            }
            [self.view bringSubviewToFront:_MovieView];
            if ([_photoView isDescendantOfView:self.view]) {
                _photoView.hidden = YES;
            }
    }
}


@end

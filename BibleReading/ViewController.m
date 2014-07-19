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
@property UIView *timeLineView;
@property UIView *planView;
@property UIView *MovieView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self createtimeLineView];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)viewListMenu:(id)sender{
    NSArray *images = @[
                        [UIImage imageNamed:@"Chats.png"],
                        [UIImage imageNamed:@"Calendar-Month.png"],
                        [UIImage imageNamed:@"Gear.png"],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    [callout show];
}

- (void)createtimeLineView{
    _timeLineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_timeLineView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_timeLineView addSubview:listBtn];
    
    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.10 green:0.84 blue:0.99 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.11 green:0.30 blue:0.94 alpha:1.0].CGColor, nil];
    [_timeLineView.layer insertSublayer:pageGradient atIndex:0];
     
    NSLog(@"1枚目");
}


- (void)createplanView{
    
    [self performSegueWithIdentifier:@"toCalendarViewController" sender:self];
    
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
            if (![_timeLineView isDescendantOfView:self.view]) {
                NSLog(@"pp");
                [self createtimeLineView];
            }
            if (_timeLineView.hidden) {
                _timeLineView.hidden = NO;
            }
            [self.view bringSubviewToFront:_timeLineView];
            if ([_planView isDescendantOfView:self.view]) {
                _planView.hidden = YES;
            }
            if ([_MovieView isDescendantOfView:self.view]) {
                _MovieView.hidden = YES;
            }
            break;
        case 1:
            if (![_planView isDescendantOfView:self.view]) {
                [self createplanView];
            }
            if (_planView.hidden) {
                _planView.hidden = NO;
            }
            [self.view bringSubviewToFront:_planView];
            if ([_timeLineView isDescendantOfView:self.view]) {
                _timeLineView.hidden = YES;
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
            if ([_timeLineView isDescendantOfView:self.view]) {
                _planView.hidden = YES;
            }
            [self.view bringSubviewToFront:_MovieView];
            if ([_planView isDescendantOfView:self.view]) {
                _planView.hidden = YES;
            }
    }
}

@end

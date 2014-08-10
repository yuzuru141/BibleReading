//
//  ViewController.m
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController (){
        UIButton *listBtn;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *timeLineView;

@end

@implementation NoticeViewController

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
                        [UIImage imageNamed:@"Calendar-Month.png"],
                        [UIImage imageNamed:@"Gear.png"],
                        [UIImage imageNamed:@"Chat.png"],
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

}



- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"toCalendarViewController" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toSettingViewController" sender:self];
            break;
        case 2:
            [self createtimeLineView];
            break;
    }
}

@end

//
//  ViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController (){
    UIButton *listBtn;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *planView;
@property RDVCalendarView *calendar;

@end



@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self firstLoad];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstLoad{
    
    self.calendar = [[RDVCalendarView alloc]init];
    self.calendar.delegate = self;
    
    [self setSideBar];
    [self buttonToRead];

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


- (void)setSideBar{
    _planView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,50)];
    [self.view addSubview:_planView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_planView addSubview:listBtn];
    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.10 green:0.84 blue:0.99 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.11 green:0.30 blue:0.94 alpha:1.0].CGColor, nil];
    
    
    [self.view.layer insertSublayer:pageGradient atIndex:0];
     
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
//            for (UIView* subview in self.view.subviews) {
//                [subview removeFromSuperview];
//            }
            [self setSideBar];
            break;
        case 1:
            [self performSegueWithIdentifier:@"calendarToSetting" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"calendarToView" sender:self];
            break;
    }
}


//デリゲートメソッド
- (void)buttonToRead{
    [self performSegueWithIdentifier:@"calendarToRead" sender:self];    
}


@end

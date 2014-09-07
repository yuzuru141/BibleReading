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
    
    //バックの色をlinenに設定
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.941 blue:0.902 alpha:1];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
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

// 常に回転させない
- (BOOL)shouldAutorotate
{
    return NO;
}

// 縦のみサポート
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


//デリゲートメソッド
- (void)buttonToRead{
    [self performSegueWithIdentifier:@"calendarToRead" sender:self];    
}


@end

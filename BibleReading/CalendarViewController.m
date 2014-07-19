//
//  CalendarViewController.m
//  Tuitamon
//
//  Created by 有田志乃 on 2014/06/19.
//  Copyright (c) 2014年 ssnet. All rights reserved.
//

#import "CalendarViewController.h"
#import "RDVExampleDayCell.h"

@interface CalendarViewController (){
    UIButton *listBtn;
}


@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *planView;

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Calendar";//石井追記
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.875 blue:0.541 alpha:1.0];

    
    //iPhoneのシステム設定にしたがって日付と時刻を取得する
    NSDate *now = [NSDate date]; //現在日付取得
    NSCalendar *baseCalender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    //iPhoneの時刻と一致した値を取得
    NSInteger flag = NSYearCalendarUnit
    | NSMonthCalendarUnit
    | NSDayCalendarUnit
    | NSDayCalendarUnit
    | NSWeekdayCalendarUnit
    | NSHourCalendarUnit
    | NSMinuteCalendarUnit;
    
    NSDateComponents *baseComponents = [baseCalender components:flag fromDate:now];
    
    NSString *str = [NSString stringWithFormat:@"%d年 %02d月 %02d日 %1d曜日 %02d:%02d",[baseComponents year],[baseComponents month],[baseComponents day],[baseComponents weekday],[baseComponents hour],[baseComponents minute]];
    
    NSLog(@"%@",str);  //曜日・・1〜7が日曜日〜土曜日

    
    
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    [[self calendarView] registerDayCellClass:[RDVExampleDayCell class]];
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:[self calendarView]
                                                                   action:@selector(showCurrentMonth)];
    [self.navigationItem setRightBarButtonItem:todayButton];
    
    
    _planView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
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
     (id)[UIColor colorWithRed:0.99 green:0.76 blue:0.46 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:1.0 green:0.55 blue:0.0 alpha:1.0].CGColor, nil];
    [_planView.layer insertSublayer:pageGradient atIndex:0];
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//石井追記
- (void)viewWillAppear:(BOOL)animated{
    
    //ここでNavigationcontrollerの色を変えてください
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.875 blue:0.541 alpha:1.0];
    self.navigationController.navigationBar.TintColor = [UIColor blueColor];

    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

//石井追記
- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index {
    RDVExampleDayCell *exampleDayCell = (RDVExampleDayCell *)dayCell;
    if (index % 5 == 0) {
        [[exampleDayCell notificationView] setHidden:NO];
    }
}

//石井追記
//- (IBAction)return:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


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



@end

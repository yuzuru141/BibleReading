//
//  CalendarViewController.m
//  Tuitamon
//
//  Created by 有田志乃 on 2014/06/19.
//  Copyright (c) 2014年 ssnet. All rights reserved.
//

#import "CalendarViewController.h"
#import "RDVExampleDayCell.h"

@interface CalendarViewController ()

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


@end

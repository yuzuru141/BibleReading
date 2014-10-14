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
        CGFloat width;
        CGFloat height;
        NSArray* aItemList3;
        NSArray* aItemList4;
        UIPickerView* oPicker3;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *settingView;

@end

@implementation NoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setViewForFirst];
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
                        [UIImage imageNamed:@"Clock.png"],
                        [UIImage imageNamed:@"Chat.png"],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    [callout show];
}

- (void)setViewForFirst{
    
    //スクリーンサイズの取得
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;
    
    [self createsettingView];
    [self setSchedule];

}

- (void)createsettingView{
    _settingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_settingView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_settingView addSubview:listBtn];
    
    //バックの色をfloralwhiteに設定
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.98 blue:0.941 alpha:1];

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
            [self createsettingView];
            break;
        case 3:
            [self performSegueWithIdentifier:@"noticeToComment" sender:self];
            break;
    }
}

//ラベル作成とピッカー読み込み
- (void)setSchedule{
    
    CGRect textRect2 = CGRectMake(width/10, height/9+30, width-width/10*2, 35);
    UILabel *notification = [[UILabel alloc]init];
    notification = [[UILabel alloc]initWithFrame:textRect2];
    notification.text = NSLocalizedString(@"Notification Setting", nil);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        notification.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
    }else{
        notification.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:35];
    }
    notification.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.7];
    [_settingView addSubview:notification];
    
    [self createPicker];
    
}


//ピッカー作成
- (void)createPicker {
    
    aItemList3 = [[NSArray alloc] initWithObjects:@"--",@"00:",@"01:",@"02:",@"03:",@"04:",@"05:",@"06:",@"07:",@"08:",@"09:",@"10:",@"11:",@"12:",@"13:",@"14:",@"15:",@"16:",@"17:",@"18:",@"19:",@"20:",@"21:",@"22:",@"23:",nil];
    aItemList4 = [[NSArray alloc] initWithObjects:@"--",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    oPicker3 = [[UIPickerView alloc] init];
    oPicker3.frame = CGRectMake(width/5, height/9*2, width-width/5*2, 50);
    oPicker3.showsSelectionIndicator = YES;
    oPicker3.delegate = self;
    oPicker3.dataSource = self;
    oPicker3.tag = 3;

    [self userSelectRow];
    [_settingView addSubview:oPicker3];
    
}


//ピッカーの表示項目を選択
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        switch (component) {
            case 0: // 1列目
                return [NSString stringWithFormat:@"%@", [aItemList3 objectAtIndex:row]];
                break;
            case 1: // 2列目
                return [NSString stringWithFormat:@"%@", [aItemList4 objectAtIndex:row]];
                break;
            default:
                return 0;
                break;
        
    }
}

//ピッカーの高さを設定する
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 100;
}

//区切りの数（コンポーネント）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
        return 2;
}


//ピッカーの項目数を選択
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        switch (component) {
            case 0: // 1列目
                return [aItemList3 count];
                break;
            case 1: // 2列目
                return [aItemList4 count];
                break;
            default:
                return 0;
                break;
        
        
    }
}


//ピッカーの文字を変更する
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:18];
    }else{
        label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:35];
    }
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    
        switch (component) {
            case 0: // 1列目
                label.text = [aItemList3 objectAtIndex:row];
                break;
            case 1: // 2列目
                label.text = [aItemList4 objectAtIndex:row];
                break;
            default:
                return 0;
                break;
        
    }
	return label;
}



//ピッカーの幅の調整
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
        switch (component) {
            case 0: // 1列目
                return 70.0;
                break;
            case 1: // 2列目
                return width-width/10*2+30;
                break;
            default:
                return 0;
                break;
        }
}

//以前にユーザが設定した時間を読み込む
-(void)userSelectRow{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger hour = [defaults integerForKey:@"notificationTimeHour"];
    NSInteger minutes = [defaults integerForKey:@"notificationTimeMinute"];

    //NSuserdefaultsから取得した情報をpickerの初期値に反映。
    [oPicker3 selectRow:hour+1 inComponent:0 animated:NO]; //１列目を一行目にセット
    [oPicker3 selectRow:minutes+1 inComponent:1 animated:NO]; //２列目を二行目にセット
    
}


//ユーザが選択した通知する時間を抜き出す
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSInteger selectNumber;
    selectNumber = [pickerView selectedRowInComponent:0];
    int hour;
    NSString *arrayComp0 = @"--";
    if ([aItemList3 objectAtIndex:selectNumber]==arrayComp0) {
        hour = 99;
    }else{
    hour = [[aItemList3 objectAtIndex:selectNumber]intValue];
        NSLog(@"hour=%d", hour);
    }

    
    NSInteger selectNumber2;
    selectNumber2 = [pickerView selectedRowInComponent:1];
    int minutes;
    if ([aItemList4 objectAtIndex:selectNumber]==arrayComp0) {
        minutes = 99;
    }else{
    minutes = [[aItemList4 objectAtIndex:selectNumber2]intValue];
        NSLog(@"minutes=%d", minutes);
    }

    
    //NSuserdefaultsへ保存
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:hour forKey:@"notificationTimeHour"];
    [defaults setInteger:minutes forKey:@"notificationTimeMinute"];
    [defaults synchronize];
    
    return;
}


//バックグラウンド状態の時に通知する。
-(void)LocalNotificationStart{
    
    //NSuserdefaultsから設定した時間を読み込む
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger hour = [defaults integerForKey:@"notificationTimeHour"];
    NSInteger minutes = [defaults integerForKey:@"notificationTimeMinute"];

    //選択した項目が"--"であれば通知をセットしない。
    if (hour==99 || minutes==99) {
        //全ての通知をキャンセルさせる
        NSLog(@"hour=%ld",(long)hour);
        NSLog(@"minutes=%ld",(long)minutes);
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSLog(@"通知セットしない");
    }else{
    
        //現在時刻から取得した時間にユーザが選択した通知時刻をセットする
        NSCalendar *currentCalendar =  [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComp = [[NSDateComponents alloc] init];
        dateComp = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit
                                   | NSDayCalendarUnit | NSHourCalendarUnit
                                   | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                         fromDate:[NSDate date]];
        dateComp.hour = hour;
        dateComp.minute = minutes;
        dateComp.second = 0;
    
        //アラートを作成
        NSDate *notificationDate = [currentCalendar dateFromComponents:dateComp];
        //通知時間 < 現在時 なら設定しない
        if ([notificationDate timeIntervalSinceNow] <= 0) {
            return;
            }
        NSLog(@"notificationDate=%@",[notificationDate descriptionWithLocale:[NSLocale currentLocale]]);;
    
        //一度全ての通知をキャンセルさせる
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        notification.fireDate = notificationDate;
        notification.repeatInterval = NSCalendarUnitDay;
        notification.shouldGroupAccessibilityChildren = YES;
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"reading time", nil)];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
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


@end

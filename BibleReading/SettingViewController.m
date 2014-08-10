//
//  SettingViewController.m
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController (){
    CGFloat width;
    CGFloat height;
    UIButton *listBtn;
    UITextField *textfield;
    NSArray*       aItemList;
    NSArray*       aItemList2;  
    NSArray*       aItemList3;
    NSArray*       aItemList4;
    UIPickerView*  oPicker;
    UIPickerView*  oPicker2;
    UIPickerView*  oPicker3;
    NSString *pic1_str;
    NSString *pic2_str;
    NSString *pic3_str;
    int selectNumber;
    int selectNumber2;
    UIDatePicker *datePicker;
    NSDateFormatter *df;
    NSMutableArray *results;
    NSMutableArray *idArrays;
    NSMutableArray *bibleName;
    NSMutableArray *bibleNameJp;
    NSMutableArray *bibleNameCn;
    NSMutableArray *general;
    NSMutableArray *oneYearGroup;
    NSMutableArray *twoYearGroup;
    NSMutableArray *dateArray;
    NSMutableArray *capter;
    NSMutableArray *verse;
    int idCount;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *settingView;

@end

@implementation SettingViewController

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
    
    [self setViewForFirst];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewForFirst{
    
    //スクリーンサイズの取得
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;
    
    [self createsettingView];
    [self writeUserName];
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
    
    
    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.10 green:0.84 blue:0.99 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.11 green:0.30 blue:0.94 alpha:1.0].CGColor, nil];
    [_settingView.layer insertSublayer:pageGradient atIndex:0];
    
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


- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"settingToPlan" sender:self];
            [self alertViewMethod];
            break;
        case 1:
            [self setViewForFirst];
            break;
        case 2:
            [self performSegueWithIdentifier:@"settingToView" sender:self];
            [self alertViewMethod];
            break;
    }
}


//ユーザ名入力
- (void)writeUserName{

    CGRect textRect = CGRectMake(width/10, height/9, width-width/10*2, 18);
    textfield = [[UITextField alloc]initWithFrame:textRect];
    textfield.placeholder = @"please input user name";
    textfield.textColor = [UIColor whiteColor];
//    textfield.backgroundColor = [UIColor whiteColor];
//    textfield.alpha = 0.5;
//    textfield.font = [UIFont fontWithName:@"STHeitiJ-Light" size:12];
    textfield.font = [UIFont systemFontOfSize:18];
    textfield.returnKeyType = UIReturnKeyDefault;
    textfield.delegate = self;
    [_settingView addSubview:textfield];
    //[self registerForKeyboardNotifications];
    
}


//textfieldでリターンキーが押されるとキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


//ラベル作成とピッカー読み込み
- (void)setSchedule{

    CGRect textRect = CGRectMake(width/10, height/9+30, width-width/10*2, 18);
    UILabel *labelPlan = [[UILabel alloc]init];
    labelPlan = [[UILabel alloc]initWithFrame:textRect];
    labelPlan.text = @"Your Plan";
    labelPlan.font = [UIFont systemFontOfSize:18];
    labelPlan.textColor = [UIColor whiteColor];
    [_settingView addSubview:labelPlan];
    
    CGRect textRect2 = CGRectMake(width/10, height/9*5-20, width-width/10*2, 18);
    UILabel *notification = [[UILabel alloc]init];
    notification = [[UILabel alloc]initWithFrame:textRect2];
    notification.text = @"Notification";
    notification.font = [UIFont systemFontOfSize:18];
    notification.textColor = [UIColor whiteColor];
    [_settingView addSubview:notification];
    
    CGRect textRect3 = CGRectMake(width/10, height/9*7-30, width-width/10*2, 18);
    UILabel *startDate = [[UILabel alloc]init];
    startDate = [[UILabel alloc]initWithFrame:textRect3];
    startDate.text = @"Start Date";
    startDate.font = [UIFont systemFontOfSize:18];
    startDate.textColor = [UIColor whiteColor];
    [_settingView addSubview:startDate];
    
    [self createPicker];
    
    [self datePickerMethod];
    
}


//ピッカー作成
- (void)createPicker {
    
    aItemList = [[NSArray alloc] initWithObjects:@"1year",@"2year",@"flexible",nil];
    oPicker = [[UIPickerView alloc] init];
    oPicker.frame = CGRectMake(width/5, height/9+30, width-width/5*2, 25);
    oPicker.showsSelectionIndicator = YES;
    oPicker.delegate = self;
    oPicker.dataSource = self;
    oPicker.tag = 1;
    CGAffineTransform t0 = CGAffineTransformMakeTranslation(oPicker.bounds.size.width/2, oPicker.bounds.size.height/2);
    CGAffineTransform s0 = CGAffineTransformMakeScale(0.7, 0.7);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(-oPicker.bounds.size.width/2, -oPicker.bounds.size.height/2);
    oPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
    [_settingView addSubview:oPicker];
    
    aItemList2 = [[NSArray alloc] initWithObjects:@"general",@"time ordering",@"recommend",nil];
    oPicker2 = [[UIPickerView alloc] init];
    oPicker2.frame = CGRectMake(width/5, height/9+100, width-width/5*2, 25);
    oPicker2.showsSelectionIndicator = YES;
    oPicker2.delegate = self;
    oPicker2.dataSource = self;
    oPicker2.tag = 2;
    CGAffineTransform t10 = CGAffineTransformMakeTranslation(oPicker.bounds.size.width/2, oPicker.bounds.size.height/2);
    CGAffineTransform s10 = CGAffineTransformMakeScale(0.7, 0.7);
    CGAffineTransform t11 = CGAffineTransformMakeTranslation(-oPicker.bounds.size.width/2, -oPicker.bounds.size.height/2);
    oPicker2.transform = CGAffineTransformConcat(t10, CGAffineTransformConcat(s10, t11));
    [_settingView addSubview:oPicker2];
    
    aItemList3 = [[NSArray alloc] initWithObjects:@"--",@"00:",@"01:",@"02:",@"03:",@"04:",@"05:",@"06:",@"07:",@"08:",@"09:",@"10:",@"11:",@"12:",@"13:",@"14:",@"15:",@"16:",@"17:",@"18:",@"19:",@"20:",@"21:",@"22:",@"23:",nil];
    aItemList4 = [[NSArray alloc] initWithObjects:@"--",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    oPicker3 = [[UIPickerView alloc] init];
    oPicker3.frame = CGRectMake(width/5, height/9*5-20, width-width/5*2, 25);
    oPicker3.showsSelectionIndicator = YES;
    oPicker3.delegate = self;
    oPicker3.dataSource = self;
    oPicker3.tag = 3;
    CGAffineTransform t20 = CGAffineTransformMakeTranslation(oPicker.bounds.size.width/2, oPicker.bounds.size.height/2);
    CGAffineTransform s20 = CGAffineTransformMakeScale(0.7, 0.7);
    CGAffineTransform t21 = CGAffineTransformMakeTranslation(-oPicker.bounds.size.width/2, -oPicker.bounds.size.height/2);
    oPicker3.transform = CGAffineTransformConcat(t20, CGAffineTransformConcat(s20, t21));
    [_settingView addSubview:oPicker3];
    
}


//ピッカーの表示項目を選択
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        pic1_str = [NSString stringWithFormat:@"%@",[aItemList objectAtIndex:row]];
        return pic1_str;
    }
    else if(pickerView.tag == 1){
        pic2_str = [NSString stringWithFormat:@"%@",[aItemList2 objectAtIndex:row]];
        return pic2_str;
    }
    else{
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
}


//区切りの数（コンポーネント）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 3) {
        return 2;
    }else{
        return 1;
    }
}


//ピッカーの項目数を選択
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        return [aItemList count];
    }
    else if (pickerView.tag == 2){
        return [aItemList2 count];
    }
    else {
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
}




//スイッチ文でDBから読み込むために選択項目をint型に変換する
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag == 1) {
        selectNumber = [pickerView selectedRowInComponent:0];
        return;
    }
    else if (pickerView.tag == 2){
        selectNumber2 = [pickerView selectedRowInComponent:0];
        return;
    }
}
 


//ピッカーの文字を変更する
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize: 20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    if (pickerView.tag == 1) {
        label.text = [aItemList objectAtIndex:row];
    }else if (pickerView.tag == 2) {
        label.text = [aItemList2 objectAtIndex:row];
    }else{
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
    }
	return label;
    
}



//ピッカーの幅の調整
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    if (pickerView.tag == 3) {
        switch (component) {
            case 0: // 1列目
                return 30.0;
                break;
            case 1: // 2列目
                return width-width/10*2+30;
                break;
            default:
                return 0;
            break;
        }
    }else{
        return width-width/10*2;
    }
}


//datepicker
- (void)datePickerMethod{
    // イニシャライザ
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(width/10, height/9*7-30, width-width/10*2, 18)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    datePicker.tintColor = [UIColor whiteColor];
    datePicker.minuteInterval = 10;
    CGAffineTransform t30 = CGAffineTransformMakeTranslation(datePicker.bounds.size.width/2, datePicker.bounds.size.height/2);
    CGAffineTransform s30 = CGAffineTransformMakeScale(0.7, 0.7);
    CGAffineTransform t31 = CGAffineTransformMakeTranslation(-datePicker.bounds.size.width/2, -datePicker.bounds.size.height/2);
    datePicker.transform = CGAffineTransformConcat(t30, CGAffineTransformConcat(s30, t31));
    [datePicker addTarget:self
                   action:@selector(datePicker_ValueChanged:)
         forControlEvents:UIControlEventValueChanged];
    [_settingView addSubview:datePicker];
    
}

//datepickerが選択されたとき
- (void)datePicker_ValueChanged:(id)sender
{
    datePicker = sender;
    df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd";
    NSLog(@"%@", [df stringFromDate:datePicker.date]);
}


//DB作成と読み込み
- (void)createAndSelectDB{
    
    self.database = [[DataBase alloc]init];
    
    //DBファイルがない場合は、DBコピーして作成
    [self.database createDB];
    
    //DB読み込み
//    NSString *arg = @"bible_name";
//    [self.database readDB:arg];
    
    //プラン決定後、ソートする。
    results = [self.database selectPlan:selectNumber label:selectNumber2];
    idArrays = [[NSMutableArray alloc]init];;
    bibleName = [[NSMutableArray alloc]init];
    bibleNameJp = [[NSMutableArray alloc]init];
    bibleNameCn = [[NSMutableArray alloc]init];
    general = [[NSMutableArray alloc]init];
    oneYearGroup = [[NSMutableArray alloc]init];
    twoYearGroup = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];
    capter = [[NSMutableArray alloc]init];
    verse = [[NSMutableArray alloc]init];
    
    idArrays = results[0];
    bibleName = results[1];
    bibleNameJp = results[2];
    bibleNameCn = results[3];
    oneYearGroup = results[4];
    twoYearGroup = results[5];
    general = results[6];
    capter = results[7];
    verse = results[8];

    
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    
    int yearGroup;
    int generalInt = 0;
    int generalIntMinus = 0;
    int j = 0;
    idCount = [idArrays count];
    
    //新しく自分用の聖書通読プランのテーブルを作成
    [self.database createTable];
    //一度現在のデータを全て削除する
    [self.database deleteDataInTable];
    
    //選択した日付から配列に入れていく。
    for (int i=0; i<idCount; i++) {
        
        if (selectNumber == 0) {
            
            yearGroup = [[oneYearGroup objectAtIndex:i]intValue];
            
            if (i==0) {
                [dateComp setDay:0];
                NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                [dateArray addObject:date];
                [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                NSLog(@"date=%@",date);
            }
            else{
                if (yearGroup == [[oneYearGroup objectAtIndex:i-1]intValue]) {
                    generalInt =[[general objectAtIndex:i]intValue];
                    generalIntMinus = [[general objectAtIndex:i-1]intValue];
                    if (!(generalInt==generalIntMinus)) {
                        j++;
                        [dateComp setDay:j];
                        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                        [dateArray addObject:date];
                        [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                        NSLog(@"date=%@",date);
                    }else{
                        [dateComp setDay:j];
                        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                        [dateArray addObject:date];
                        [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                        NSLog(@"date=%@",date);
                    }
                }else{
                    j++;
                    [dateComp setDay:j];
                    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                    [dateArray addObject:date];
                    [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                    NSLog(@"date=%@",date);
                }
            }
            
        }else{
            
            yearGroup = [[twoYearGroup objectAtIndex:i]intValue];
            
            if (i==0) {
                [dateComp setDay:0];
                NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                [dateArray addObject:date];
                [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                NSLog(@"date=%@",date);
            }
            else{
                if (yearGroup == [[twoYearGroup objectAtIndex:i-1]intValue]) {
                    generalInt =[[general objectAtIndex:i]intValue];
                    generalIntMinus = [[general objectAtIndex:i-1]intValue];
                    if (!(generalInt==generalIntMinus)) {
                        j++;
                        [dateComp setDay:j];
                        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                        [dateArray addObject:date];
                        [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                        NSLog(@"date=%@",date);
                    }else{
                        [dateComp setDay:j];
                        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                        [dateArray addObject:date];
                        [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
//                        NSLog(@"date=%@",date);
                    }
                }else{
                    j++;
                    [dateComp setDay:j];
                    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:datePicker.date options:0];
                    [dateArray addObject:date];
                    [self.database insertTable:i label1:[bibleName objectAtIndex:i] label2:[bibleNameJp objectAtIndex:i] label3:[bibleNameCn objectAtIndex:i] label4:[[capter objectAtIndex:i]intValue] label5:[verse objectAtIndex:i] label6:date];
                    NSLog(@"date=%@",date);
                }
        }
        }
    }
    
}


//- (void)createMyplan{
//    
//    //新しく自分用の聖書通読プランのテーブルを作成
//    [self.database createTable];
//    
//    //テーブルにデータを入れこむ
//    int i;
//    for (i=0; i<idCount; i++) {
//            [self.database insertTable:<#(int)#> label1:<#(NSString *)#> label2:<#(NSString *)#> label3:<#(NSString *)#> label4:<#(int)#> label5:<#(int)#> label6:<#(NSDate *)#>];
//    }
//}





//画面遷移時に設定確認
- (void)alertViewMethod{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Setting is done. Your reading plan will be overwritten."
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    [alert show];
}


//alertにOKが表示された時にDBを作成する
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"cancel");
            break;
        case 1:
            [self createAndSelectDB];
            NSLog(@"OK");
            break;
    }
    
}

@end

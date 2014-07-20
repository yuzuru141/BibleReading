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
                        [UIImage imageNamed:@"Chats.png"],
                        [UIImage imageNamed:@"Calendar-Month.png"],
                        [UIImage imageNamed:@"Gear.png"],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    [callout show];
}


- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"settingToView" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"settingToPlan" sender:self];
            break;
        case 2:
            [self setViewForFirst];
            break;
    }
}


//ユーザ名入力
- (void)writeUserName{

    CGRect textRect = CGRectMake(width/10, height/6, width-width/10*2, 25);
    textfield = [[UITextField alloc]initWithFrame:textRect];
    textfield.placeholder = @"please input user name";
    textfield.textColor = [UIColor whiteColor];
//    textfield.backgroundColor = [UIColor whiteColor];
//    textfield.alpha = 0.5;
//    textfield.font = [UIFont fontWithName:@"STHeitiJ-Light" size:12];
    textfield.font = [UIFont systemFontOfSize:20];
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

    CGRect textRect = CGRectMake(width/10, height/6+50, width-width/10*2, 25);
    UILabel *labelPlan = [[UILabel alloc]init];
    labelPlan = [[UILabel alloc]initWithFrame:textRect];
    labelPlan.text = @"Your Plan";
    labelPlan.font = [UIFont systemFontOfSize:20];
    labelPlan.textColor = [UIColor whiteColor];
    [_settingView addSubview:labelPlan];
    
    CGRect textRect2 = CGRectMake(width/10, height/6*4+20, width-width/10*2, 25);
    UILabel *notification = [[UILabel alloc]init];
    notification = [[UILabel alloc]initWithFrame:textRect2];
    notification.text = @"Notification";
    notification.font = [UIFont systemFontOfSize:20];
    notification.textColor = [UIColor whiteColor];
    [_settingView addSubview:notification];
    
    [self createPicker];
    
}


//ピッカー作成
- (void)createPicker {
    
    aItemList = [[NSArray alloc] initWithObjects:@"1year",@"2year",@"flexible",nil];
    oPicker = [[UIPickerView alloc] init];
    oPicker.frame = CGRectMake(width/5, height/6+50, width-width/5*2, 25);
    oPicker.showsSelectionIndicator = YES;
    oPicker.delegate = self;
    oPicker.dataSource = self;
    oPicker.tag = 1;
//    CGAffineTransform t0 = CGAffineTransformMakeTranslation(oPicker.bounds.size.width/2, oPicker.bounds.size.height/2);
//    CGAffineTransform s0 = CGAffineTransformMakeScale(0.7, 0.7);
//    CGAffineTransform t1 = CGAffineTransformMakeTranslation(-oPicker.bounds.size.width/2, -oPicker.bounds.size.height/2);
//    oPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
    [_settingView addSubview:oPicker];
    
    aItemList2 = [[NSArray alloc] initWithObjects:@"general",@"time ordering",@"recommend",nil];
    oPicker2 = [[UIPickerView alloc] init];
    oPicker2.frame = CGRectMake(width/5, height/6+120, width-width/5*2, 25);
    oPicker2.showsSelectionIndicator = YES;
    oPicker2.delegate = self;
    oPicker2.dataSource = self;
    oPicker2.tag = 2;
    [_settingView addSubview:oPicker2];
    
    aItemList3 = [[NSArray alloc] initWithObjects:@"--",@"00:",@"01:",@"02:",@"03:",@"04:",@"05:",@"06:",@"07:",@"08:",@"09:",@"10:",@"11:",@"12:",@"13:",@"14:",@"15:",@"16:",@"17:",@"18:",@"19:",@"20:",@"21:",@"22:",@"23:",nil];
    aItemList4 = [[NSArray alloc] initWithObjects:@"--",@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    oPicker3 = [[UIPickerView alloc] init];
    oPicker3.frame = CGRectMake(width/5, height/6*4+10, width-width/5*2, 25);
    oPicker3.showsSelectionIndicator = YES;
    oPicker3.delegate = self;
    oPicker3.dataSource = self;
    oPicker3.tag = 3;
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



/*
//選択完了時に呼ばれる
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //選択行を返す
    NSInteger id = [pickerView selectedRowInComponent:0];
    NSInteger id2 = [pickerView selectedRowInComponent:1];
    labelPlan.text  = [NSString stringWithFormat:@"Your Plan :%@ %@",aItemList[id],aItemList2[id2]];
}
 */


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

@end

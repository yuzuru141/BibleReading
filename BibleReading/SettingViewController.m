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
    UILabel *labelPlan;
    NSArray*       aItemList;
    NSArray*       aItemList2;
    UIPickerView*  oPicker;
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
    
    NSLog(@"3枚目");
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

    CGRect textRect = CGRectMake(width/10, height/5, width-width/10*2, 25);
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

- (void)setSchedule{

    CGRect textRect = CGRectMake(width/10, height/5+50, width-width/10*2, 25);
    labelPlan = [[UILabel alloc]initWithFrame:textRect];
    labelPlan.text = @"Your Plan";
    labelPlan.font = [UIFont systemFontOfSize:15];
    labelPlan.textColor = [UIColor whiteColor];
    
    [_settingView addSubview:labelPlan];
    
    [self showPicker];
    
}

- (void)showPicker {
    
    //ピッカーにアイテムを格納
    aItemList = [[NSArray alloc] initWithObjects:@"1year",@"2year",@"flexible",nil];
    aItemList2 = [[NSArray alloc] initWithObjects:@"general",@"time ordering",@"recommend",nil];
    // ピッカーの生成
    oPicker = [[UIPickerView alloc] init];
    oPicker.frame = CGRectMake(width/5, height/5+50, width-width/5*2, 25);
    oPicker.showsSelectionIndicator = YES;
    oPicker.delegate = self;
    oPicker.dataSource = self;
    [_settingView addSubview:oPicker];
    
    
}



- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"%@", [aItemList objectAtIndex:row]];
            break;
        case 1: // 2列目
            return [NSString stringWithFormat:@"%@", [aItemList2 objectAtIndex:row]];
            break;
        default:
            return 0;
            break;
    }
}


//区切りの数（コンポーネント）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//コンポーネントの行数を返す
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [aItemList count];
}


//選択完了時に呼ばれる
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //選択行を返す
    NSInteger id = [pickerView selectedRowInComponent:0];
    NSInteger id2 = [pickerView selectedRowInComponent:1];
    labelPlan.text  = [NSString stringWithFormat:@"Your Plan :%@ %@",aItemList[id],aItemList2[id2]];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 100.0;
            break;
        case 1: // 2列目
            return 100.0;
            break;
        default:
            return 0;
            break;
    }
}

@end

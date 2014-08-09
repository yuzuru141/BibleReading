//
//  ReadViewController.m
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController (){
    int intDate;
    CGFloat width;
    CGFloat height;
    UIButton *backBtn;
    NSMutableArray *idArray;
    NSMutableArray *bibleName;
    NSMutableArray *bibleNameJp;
    NSMutableArray *bibleNameCn;
    NSMutableArray *capter;
    NSMutableArray *verse;
}
@property UIView *settingView;

@end

@implementation ReadViewController

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
    
    [self selectedDate];
    
    [self setViewForFirst];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//カレンダーで選択した日付を読み込む
- (void)selectedDate{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    intDate = [defaults integerForKey:@"DATE"];
    NSLog(@"calenderDate=%d",intDate);
    
    self.database = [[DataBase alloc]init];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    idArray = [[NSMutableArray alloc]init];
    bibleName = [[NSMutableArray alloc]init];
    bibleNameJp = [[NSMutableArray alloc]init];
    bibleNameCn = [[NSMutableArray alloc]init];
    capter = [[NSMutableArray alloc]init];
    verse = [[NSMutableArray alloc]init];
    
    resultArray = [self.database dbLoadByDate:intDate];

    idArray = resultArray[0];
    bibleName = resultArray[1];
    bibleNameJp = resultArray[2];
    bibleNameCn = resultArray[3];
    capter = resultArray[4];
    verse = resultArray[5];
    
    int i;
//    for (i=0; i<[resultArray[4] count]; i++) {
//        
//        NSLog(@"idArray count=%d",[resultArray[4] count]);
//        NSLog(@"chapter=%d",[[resultArray[4] objectAtIndex:i]integerValue]);
//        
//    }
//    
//    for (i=0; i<[capter count]; i++) {
//        
//        NSLog(@"idArray count=%d",[capter count]);
//        NSLog(@"chapter=%d",[[capter objectAtIndex:i]integerValue]);
//        
//    }
// 
    for (i=0; i<[idArray count]; i++) {
        
                NSLog(@"idArray count=%d",[idArray count]);
                NSLog(@"chapter=%d",[[capter objectAtIndex:i]integerValue]);
    }
}

- (void)setViewForFirst{
    
    //スクリーンサイズの取得
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;
    
    [self createsettingView];
    
}


- (void)createsettingView{
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;

    //Viewの色
    _settingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_settingView];
    
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.view.bounds;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.10 green:0.84 blue:0.99 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.11 green:0.30 blue:0.94 alpha:1.0].CGColor, nil];
    [_settingView.layer insertSublayer:pageGradient atIndex:0];
    
    //戻るボタンの作成
    backBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 50, 32)];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backBtn addTarget:self
                action:@selector(toBack:) forControlEvents:UIControlEventTouchUpInside];
    [_settingView addSubview:backBtn];
    
    //聖書ラベルの作成
    int i;
    for (i=0; i<[idArray count]; i++) {
        
        CGRect bibleNameRect = CGRectMake(width/8, 70+i*40, width-40, 15);
        UILabel *bibleLabel = [[UILabel alloc]initWithFrame:bibleNameRect];
        bibleLabel.text = [bibleName objectAtIndex:i];
        bibleLabel.textColor = [UIColor whiteColor];
        bibleLabel.font = [UIFont systemFontOfSize:15];
        [_settingView addSubview:bibleLabel];
        
    }
    
    //章ラベルの作成
    for (i=0; i<[idArray count]; i++) {
        
        NSLog(@"idArray count=%d",[idArray count]);
        NSLog(@"chapter=%d",[[capter objectAtIndex:i]integerValue]);
        
        CGRect chapterRect = CGRectMake(width/8*3, 70+i*40, width-40, 15);
        UILabel *chaperLabel = [[UILabel alloc]initWithFrame:chapterRect];
        chaperLabel.text = [NSString stringWithFormat:@"%d",[[capter objectAtIndex:i]integerValue]];
        chaperLabel.textColor = [UIColor whiteColor];
        chaperLabel.font = [UIFont systemFontOfSize:15];
        [_settingView addSubview:chaperLabel];

    }
    
    
    //節ラベルの作成
    for (i=0; i<[idArray count]; i++) {
        
        NSString *verseString = [verse objectAtIndex:i];
        //節情報があるところだけラベル表示する
        if (![verseString length]==0) {
        CGRect verseRect = CGRectMake(width/8*4, 70+i*40, width-40, 15);
        UILabel *verseLabel = [[UILabel alloc]initWithFrame:verseRect];
        verseLabel.text = [NSString stringWithFormat:@": %@",[verse objectAtIndex:i]];
        verseLabel.textColor = [UIColor whiteColor];
        verseLabel.font = [UIFont systemFontOfSize:15];
        [_settingView addSubview:verseLabel];
        }
        
    }
    
    //読んだかどうかチェックボックス作成
     for (i=0; i<[idArray count]; i++) {
         CGRect readRect = CGRectMake(width/8*6, 65+i*40, width-40, 15);
         UISwitch *sw = [[UISwitch alloc] initWithFrame:readRect];
         sw.on = NO;
         sw.onTintColor = [UIColor blackColor];
         // 値が変更された時にhogeメソッドを呼び出す
         [sw addTarget:self action:@selector(readOrNotSwitch:) forControlEvents:UIControlEventValueChanged];
         [_settingView addSubview:sw];
     }
}


//読んだかどうかスイッチで呼ばれるメソッド
- (IBAction)readOrNotSwitch:(id)sender{
    //www.jw.orgから聖書をモーダルビューで表示
    
}


//バックボタンの動作
- (IBAction)toBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

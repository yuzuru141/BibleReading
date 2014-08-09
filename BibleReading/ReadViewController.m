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
    UIWebView *webView;
    UISwitch *sw;
    BOOL read;
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
    
    //仮に作成
    read = 0;
    
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
               initWithFrame:CGRectMake(15, 25, 100, 32)];
    [backBtn setTitle:@"toCalender" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backBtn addTarget:self
                action:@selector(toCalender:) forControlEvents:UIControlEventTouchUpInside];
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
         sw = [[UISwitch alloc] initWithFrame:readRect];
         sw.on = NO;
         sw.tag = i;
         sw.onTintColor = [UIColor blackColor];
         // 値が変更された時にhogeメソッドを呼び出す
         [sw addTarget:self action:@selector(readOrNotSwitch:) forControlEvents:UIControlEventValueChanged];
         [_settingView addSubview:sw];
     }
}


//読んだかどうかスイッチで呼ばれるメソッド
- (IBAction)readOrNotSwitch:(UISwitch*)sender{
    
    if (read == 0) {
    //www.jw.orgから聖書をモーダルビューで表示
    switch (sender.tag) {
        case 0:
            [self readFromJwOrg:[bibleName objectAtIndex:0] label1:[[capter objectAtIndex:0]integerValue]];
            break;
        case 1:
            [self readFromJwOrg:[bibleName objectAtIndex:1] label1:[[capter objectAtIndex:1]integerValue]];
            break;
        case 2:
            [self readFromJwOrg:[bibleName objectAtIndex:2] label1:[[capter objectAtIndex:2]integerValue]];
            break;
        case 3:
            [self readFromJwOrg:[bibleName objectAtIndex:3] label1:[[capter objectAtIndex:3]integerValue]];
            break;
        case 4:
            [self readFromJwOrg:[bibleName objectAtIndex:4] label1:[[capter objectAtIndex:4]integerValue]];
            break;
        case 5:
            [self readFromJwOrg:[bibleName objectAtIndex:5] label1:[[capter objectAtIndex:5]integerValue]];
            break;
        case 6:
            [self readFromJwOrg:[bibleName objectAtIndex:6] label1:[[capter objectAtIndex:6]integerValue]];
            break;
        case 7:
            [self readFromJwOrg:[bibleName objectAtIndex:7] label1:[[capter objectAtIndex:7]integerValue]];
            break;
        case 8:
            [self readFromJwOrg:[bibleName objectAtIndex:8] label1:[[capter objectAtIndex:8]integerValue]];
            break;
        case 9:
            [self readFromJwOrg:[bibleName objectAtIndex:9] label1:[[capter objectAtIndex:9]integerValue]];
            break;
        default:
            break;
    }
        read = 1;
    }else{
        read = 0;
    }
}

//jw.orgから聖書を読み込む
- (void)readFromJwOrg:(NSString*)BIBLENAME label1:(int)CHAPTER{
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,60,self.view.bounds.size.width,self.view.bounds.size.height)];
    NSString *urlString = [NSString stringWithFormat:@"http://www.jw.org/en/publications/bible/nwt/books/%@/%d/",BIBLENAME,CHAPTER];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [_settingView addSubview:webView];
    
    //戻るボタンの作成
    UIButton *backBtn2 = [[UIButton alloc]
               initWithFrame:CGRectMake(120, 25, 50, 32)];
    [backBtn2 setTitle:@"toDate" forState:UIControlStateNormal];
    [backBtn2.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backBtn2 addTarget:self
                action:@selector(deleteWebView:) forControlEvents:UIControlEventTouchUpInside];
    [_settingView addSubview:backBtn2];
    
}


//バックボタンの動作
- (IBAction)toCalender:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//webView削除
- (IBAction)deleteWebView:(id)sender{
        [webView removeFromSuperview];
}


@end

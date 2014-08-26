//
//  ReadViewController.m
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController (){
    NSString *countryCode;
    NSString *countryCodeEn;
    NSString *countryCodeJa;
    NSString *countryCodeCn;
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
    NSMutableArray *readOrNot;
    UIWebView *webView;
    UISwitch *sw;
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
    
    //デバイスの言語設定を読む
    countryCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"countryCode=%@",countryCode);
    countryCodeEn = @"en";
    countryCodeJa = @"ja";
    countryCodeCn = @"zh-Hans";
    
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
    readOrNot = [[NSMutableArray alloc]init];
    
    resultArray = [self.database dbLoadByDate:intDate];

    idArray = resultArray[0];
    bibleName = resultArray[1];
    bibleNameJp = resultArray[2];
    bibleNameCn = resultArray[3];
    capter = resultArray[4];
    verse = resultArray[5];
    readOrNot = resultArray[6];
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
        
        CGRect bibleNameRect = CGRectMake(width/9, 70+i*40, width-40, 15);
        UILabel *bibleLabel = [[UILabel alloc]initWithFrame:bibleNameRect];
        if ([countryCode isEqualToString: countryCodeEn]) {
            bibleLabel.text = [bibleName objectAtIndex:i];
            NSLog(@"countryCodeEn=%@",countryCodeEn);
        }else if([countryCode isEqualToString: countryCodeJa]){
            bibleLabel.text = [bibleNameJp objectAtIndex:i];
            NSLog(@"countryCodeJa=%@",countryCodeJa);
        }else if([countryCode isEqualToString: countryCodeCn]){
            bibleLabel.text = [bibleNameCn objectAtIndex:i];
            NSLog(@"countryCodeCn=%@",countryCodeCn);
        }
        bibleLabel.textColor = [UIColor whiteColor];
        bibleLabel.font = [UIFont systemFontOfSize:15];
        [_settingView addSubview:bibleLabel];
        
    }
    
    //章ラベルの作成
    for (i=0; i<[idArray count]; i++) {
        
        //章があるところだけラベル表示する
        if (![[capter objectAtIndex:i]intValue]==0) {
        CGRect chapterRect = CGRectMake(width/9*4, 70+i*40, width-40, 15);
        UILabel *chaperLabel = [[UILabel alloc]initWithFrame:chapterRect];
        chaperLabel.text = [NSString stringWithFormat:@"%d",[[capter objectAtIndex:i]integerValue]];
        chaperLabel.textColor = [UIColor whiteColor];
        chaperLabel.font = [UIFont systemFontOfSize:15];
        [_settingView addSubview:chaperLabel];
        }
    }
    
    //節ラベルの作成
    for (i=0; i<[idArray count]; i++) {
        
        NSString *verseString = [verse objectAtIndex:i];
        //節情報があるところだけラベル表示する
        if ([verseString length]>1) {
        CGRect verseRect = CGRectMake(width/9*5, 70+i*40, width-40, 15);
        UILabel *verseLabel = [[UILabel alloc]initWithFrame:verseRect];
        verseLabel.text = [NSString stringWithFormat:@": %@",[verse objectAtIndex:i]];
        verseLabel.textColor = [UIColor whiteColor];
        verseLabel.font = [UIFont systemFontOfSize:15];
        [_settingView addSubview:verseLabel];
        }
        
    }
    
    //読んだかどうかチェックボックス作成
     for (i=0; i<[idArray count]; i++) {
         CGRect readRect = CGRectMake(width/9*7, 65+i*40, width-40, 15);
         sw = [[UISwitch alloc] initWithFrame:readRect];
         sw.tag = i;
         sw.onTintColor = [UIColor blackColor];
        
         if ([[readOrNot objectAtIndex:i]integerValue]==0) {
                      sw.on = NO;
         }else{
                      sw.on = YES;
         }
         
         // 値が変更された時にメソッドを呼び出す
         [sw addTarget:self action:@selector(readOrNotSwitch:) forControlEvents:UIControlEventValueChanged];
         [_settingView addSubview:sw];
     }
}


//読んだかどうかスイッチで呼ばれるメソッド
- (IBAction)readOrNotSwitch:(UISwitch*)sender{
    
    //www.jw.orgから聖書をモーダルビューで表示
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *readOrNotIndivisualArray = [[NSMutableArray alloc]init];
    switch (sender.tag) {
        case 0:
            //DBからUIswitchの最新状態を確認し、動作すればそれもDBに保存する。
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:0]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:0 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:0]integerValue] == 0) {
                    if ([countryCode isEqualToString: countryCodeEn]) {
                            [self readFromJwOrg:[bibleName objectAtIndex:0] label1:[[capter objectAtIndex:0]integerValue]];
                    }else if ([countryCode isEqualToString: countryCodeJa]) {
                         [self readFromJwOrg:[bibleNameJp objectAtIndex:0] label1:[[capter objectAtIndex:0]integerValue]];
                    }else if ([countryCode isEqualToString: countryCodeCn]) {
                         [self readFromJwOrg:[bibleNameCn objectAtIndex:0] label1:[[capter objectAtIndex:0]integerValue]];
                    }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:0]integerValue]];
            }else{
                 [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:0]integerValue]];
            }
            break;
        case 1:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:1]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:1 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:1]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:1] label1:[[capter objectAtIndex:1]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:1] label1:[[capter objectAtIndex:1]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:1] label1:[[capter objectAtIndex:1]integerValue]];
                }

                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:1]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:1]integerValue]];
            }
            break;
        case 2:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:2]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:2 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:2]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:2] label1:[[capter objectAtIndex:2]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:2] label1:[[capter objectAtIndex:2]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:2] label1:[[capter objectAtIndex:2]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:2]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:2]integerValue]];
            }
            break;
        case 3:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:3]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:3 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:3]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:3] label1:[[capter objectAtIndex:3]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:3] label1:[[capter objectAtIndex:3]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:3] label1:[[capter objectAtIndex:3]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:3]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:3]integerValue]];
            }
            break;
        case 4:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:4]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:4 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:4]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:4] label1:[[capter objectAtIndex:4]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:4] label1:[[capter objectAtIndex:4]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:4] label1:[[capter objectAtIndex:4]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:4]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:4]integerValue]];
            }
            break;
        case 5:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:5]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:5 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:5]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:5] label1:[[capter objectAtIndex:5]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:5] label1:[[capter objectAtIndex:5]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:5] label1:[[capter objectAtIndex:5]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:5]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:5]integerValue]];
            }
            break;
        case 6:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:6]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:6 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:6]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:6] label1:[[capter objectAtIndex:6]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:6] label1:[[capter objectAtIndex:6]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:6] label1:[[capter objectAtIndex:6]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:6]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:6]integerValue]];
            }
            break;
        case 7:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:7]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:7 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:7]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:7] label1:[[capter objectAtIndex:7]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:7] label1:[[capter objectAtIndex:7]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:7] label1:[[capter objectAtIndex:7]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:7]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:7]integerValue]];
            }
            break;
        case 8:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:8]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:8 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:8]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:8] label1:[[capter objectAtIndex:8]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:8] label1:[[capter objectAtIndex:8]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:8] label1:[[capter objectAtIndex:8]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:8]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:8]integerValue]];
            }
            break;
        case 9:
            resultArray = [self.database dbLoadReadOrNot:[[idArray objectAtIndex:9]integerValue]];
            readOrNotIndivisualArray = resultArray[0];
            [readOrNot replaceObjectAtIndex:9 withObject:[readOrNotIndivisualArray objectAtIndex:0]];
            if ([[readOrNot objectAtIndex:9]integerValue] == 0) {
                if ([countryCode isEqualToString: countryCodeEn]) {
                    [self readFromJwOrg:[bibleName objectAtIndex:9] label1:[[capter objectAtIndex:9]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeJa]) {
                    [self readFromJwOrg:[bibleNameJp objectAtIndex:9] label1:[[capter objectAtIndex:9]integerValue]];
                }else if ([countryCode isEqualToString: countryCodeCn]) {
                    [self readFromJwOrg:[bibleNameCn objectAtIndex:9] label1:[[capter objectAtIndex:9]integerValue]];
                }
                [self.database dbUpdateReadOrNot:[[idArray objectAtIndex:9]integerValue]];
            }else{
                [self.database dbDeleteReadOrNot:[[idArray objectAtIndex:9]integerValue]];
            }
            break;
        default:
            break;
    }
}

//jw.orgから聖書を読み込む
- (void)readFromJwOrg:(NSString*)BIBLENAME label1:(int)CHAPTER{
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,60,self.view.bounds.size.width,self.view.bounds.size.height)];
    
    NSString *urlString;
    
    if ([countryCode isEqualToString: countryCodeEn]) {
        urlString = [NSString stringWithFormat:@"http://www.jw.org/en/publications/bible/nwt/books/%@/%d/",BIBLENAME,CHAPTER];
    }else if ([countryCode isEqualToString: countryCodeJa]) {
         NSString *kariString = [NSString stringWithFormat:@"http://www.jw.org/ja/出版物/聖書/nwt/各書/%@/%d/",BIBLENAME,CHAPTER];
        urlString = [kariString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else if ([countryCode isEqualToString: countryCodeCn]) {
            NSString *kariString = [NSString stringWithFormat:@"http://www.jw.org/zh-hans/出版物/圣经/nwt/圣经经卷/%@/%d/",BIBLENAME,CHAPTER];
            urlString = [kariString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
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

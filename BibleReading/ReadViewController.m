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
    UIButton *backCalender;
    UIButton *backDate;
    NSMutableArray *idArray;
    NSMutableArray *bibleName;
    NSMutableArray *bibleNameJp;
    NSMutableArray *bibleNameCn;
    NSMutableArray *capter;
    NSMutableArray *verse;
    NSMutableArray *readOrNot;
    NSMutableArray *comment;
    UIWebView *webViewJWORG;
    UISwitch *sw;
    BOOL toDate;
    UIScrollView *scrollAllView;
    UITextField *textfield;
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
    
    //リーディングプランを設定していない時はアラートを出す。
    [self alertForFirst];
    
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
    comment = [[NSMutableArray alloc]init];
    
    resultArray = [self.database dbLoadByDate:intDate];
    
    idArray = resultArray[0];
    bibleName = resultArray[1];
    bibleNameJp = resultArray[2];
    bibleNameCn = resultArray[3];
    capter = resultArray[4];
    verse = resultArray[5];
    readOrNot = resultArray[6];
    comment = resultArray[7];
}
- (void)setViewForFirst{
    
    //スクリーンサイズの取得
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;
    
    [self createsettingView];
    
}


//それぞれのラベルを作成
- (void)createsettingView{
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;
    NSLog(@"height=%f",height);
    
    //Viewの色
    _settingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_settingView];
    
    //バックの色をfloralwhiteに設定
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.98 blue:0.941 alpha:1];
    
    //全体にUIScrollviewを作成
    scrollAllView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [_settingView addSubview:scrollAllView];
    
    //戻るボタンの作成
    backCalender = [[UIButton alloc]
                    initWithFrame:CGRectMake(0, 25, 100, 32)];
    [backCalender setTitle:NSLocalizedString(@"toCalender", nil) forState:UIControlStateNormal];
    [backCalender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backCalender.titleLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:15]];
    [backCalender addTarget:self
                     action:@selector(toCalender:) forControlEvents:UIControlEventTouchUpInside];
    [scrollAllView addSubview:backCalender];
    
    //聖書ラベルの作成
    int i;
    for (i=0; i<[idArray count]; i++) {
        
        CGRect bibleNameRect = CGRectMake(width/9, 50+i*height/12, width-40, 30);
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
        bibleLabel.textColor = [UIColor blackColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            bibleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
        }else{
            bibleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
        }
        [scrollAllView addSubview:bibleLabel];
        
    }
    
    //章ラベルの作成
    for (i=0; i<[idArray count]; i++) {
        
        //章があるところだけラベル表示する
        if (![[capter objectAtIndex:i]intValue]==0) {
            CGRect chapterRect = CGRectMake(width/9*4, 50+i*height/12, width-40, 30);
            UILabel *chaperLabel = [[UILabel alloc]initWithFrame:chapterRect];
            chaperLabel.text = [NSString stringWithFormat:@"%d",[[capter objectAtIndex:i]integerValue]];
            chaperLabel.textColor = [UIColor blackColor];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                chaperLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
            }else{
                chaperLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
            }
            [scrollAllView addSubview:chaperLabel];
        }
    }
    
    //節ラベルの作成
    for (i=0; i<[idArray count]; i++) {
        
        NSString *verseString = [verse objectAtIndex:i];
        //節情報があるところだけラベル表示する
        if ([verseString length]>1) {
            CGRect verseRect = CGRectMake(width/9*5, 50+i*height/12, width-40, 30);
            UILabel *verseLabel = [[UILabel alloc]initWithFrame:verseRect];
            verseLabel.text = [NSString stringWithFormat:@": %@",[verse objectAtIndex:i]];
            verseLabel.textColor = [UIColor blackColor];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                verseLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
            }else{
                verseLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
            }
            [scrollAllView addSubview:verseLabel];
        }
        
    }
    
    //読んだかどうかチェックボックス作成
    for (i=0; i<[idArray count]; i++) {
        CGRect readRect;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            readRect = CGRectMake(width/9*7, 50+i*height/12, width-40, 15);
        }else{
            readRect = CGRectMake(width/9*7, 50+i*height/12, width-40, 30);
        }
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
        [scrollAllView addSubview:sw];
    }
    
    //コメント欄作成
    BOOL exist = [self.database existDataFolderOrNot];
    if (exist) {
        CGRect textRect;
//        CGRect textRect2;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            textRect = CGRectMake(width/9, 50+10*height/12, width-width/9*2, 15);
//            textRect2 = CGRectMake(width/10, 50+10*height/12, width-width/10*2, 15);
        }else{
            textRect = CGRectMake(width/9, 50+10*height/12, width-width/9*2, 30);
        }
        textfield = [[UITextField alloc]initWithFrame:textRect];
        if ([[comment objectAtIndex:0] isEqualToString:@" "]) {
            textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"comment", nil)
                                                                              attributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
//            textfield.placeholder = NSLocalizedString(@"comment", nil);
        }else{
            textfield.text = [comment objectAtIndex:0] ;
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            textfield.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
        }else{
            textfield.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
        }
        textfield.textColor = [UIColor whiteColor];
        textfield.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
        textfield.layer.cornerRadius =3;
        textfield.returnKeyType = UIReturnKeyDefault;
        textfield.delegate = self;
        [scrollAllView addSubview:textfield];
        [self registerForKeyboardNotifications];
    }
}


//Viewがロードされるタイミングで呼ばれる関数
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


//キーボード表示関数
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGPoint scrollPoint = CGPointMake(0.0,250.0);
    [scrollAllView setContentOffset:scrollPoint animated:YES];
}


//キーボードを隠す関数
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [scrollAllView setContentOffset:CGPointZero animated:YES];
}


//textfieldでリターンキーが押されるとキーボードを隠し、コメントをDBに保存する。
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.database updateComment:intDate TEXT:textField.text];
    [textField resignFirstResponder];
    return YES;
}


//読んだかどうかスイッチで呼ばれるメソッド
- (IBAction)readOrNotSwitch:(UISwitch*)sender{
    
    //www.jw.orgから聖書をWEBビューで表示
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
    
    webViewJWORG = [[UIWebView alloc]initWithFrame:CGRectMake(0,60,self.view.bounds.size.width,self.view.bounds.size.height)];
    
    webViewJWORG.delegate = self;
    
    [BNIndicator showForView:webViewJWORG withMessage:@"Loading"];
    
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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];

    NSHTTPURLResponse* resp;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:nil];
    
    //通信エラーであれば、警告を出す
        if (resp.statusCode != 200){
            [self alertViewMethod];
            return;
        }

    [webViewJWORG loadRequest:request];
    [_settingView addSubview:webViewJWORG];
    
    //戻るボタンの作成
    backDate = [[UIButton alloc]
               initWithFrame:CGRectMake(70, 25, 100, 32)];
    [backDate setTitle:NSLocalizedString(@"toDate", nil) forState:UIControlStateNormal];
    [backDate setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backDate.titleLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:15]];
    [backDate addTarget:self
                action:@selector(deleteWebView:) forControlEvents:UIControlEventTouchUpInside];
    [_settingView addSubview:backDate];
    
    //toDateボタンを表示する
    toDate = YES;
    if (toDate==YES) {
        backDate.hidden = NO;
    }
    
}



//読み込み失敗時に呼ばれる関数
- (void)alertViewMethod{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"networkConncetionError", nil)
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK",nil];
    [alert show];
}


//リーディングプランを全く設定していない場合は、設定するようにアラートを出す
- (void)alertForFirst{
    
    self.database = [[DataBase alloc]init];
    
    BOOL exist = [self.database existDataFolderOrNot];
    
    if (!exist) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please set your reading plan", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
        [alert show];
    }
}


// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [BNIndicator hideForView:webViewJWORG];
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


//バックボタンの動作
- (IBAction)toCalender:(id)sender{
    [self performSegueWithIdentifier:@"readToCalender" sender:self];
}

//webView削除
- (IBAction)deleteWebView:(id)sender{
        [webViewJWORG removeFromSuperview];
    //戻るボタンを消す
    toDate = NO;
    if (toDate==NO) {
        backDate.hidden = YES;
    }
}


@end

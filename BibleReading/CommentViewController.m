//
//  CommentViewController.m
//  BibleReading
//
//  Created by 石井嗣 on 2014/10/11.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController (){
    UIButton *listBtn;
    int intDate;
    CGFloat width;
    CGFloat height;
    NSMutableArray *dateArray;
    NSMutableArray *commentArray;
    UIScrollView *scrollAllView;
    UITextField *textfield;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *settingView;


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self firstLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstLoad{
    
    [self createsettingView];
    [self setSideBar];
    [self selectedDate];
    
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


- (void)setSideBar{
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [scrollAllView addSubview:listBtn];
    
    //バックの色をfloralwhiteに設定
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.98 blue:0.941 alpha:1];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"commentToCalendar" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"commentToSetting" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"commentToNotice" sender:self];
            break;
        case 3:
            break;
    }
}


//それぞれのラベルを作成
- (void)createsettingView{
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    width = screenSize.size.width;
    height = screenSize.size.height;
    
    //Viewの色
    _settingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:_settingView];
    
    //バックの色をfloralwhiteに設定
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.98 blue:0.941 alpha:1];
    
    //全体にUIScrollviewを作成
    scrollAllView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [_settingView addSubview:scrollAllView];
}


//カレンダーで選択した日付を読み込む
- (void)selectedDate{
    
    self.database = [[DataBase alloc]init];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];
    commentArray = [[NSMutableArray alloc]init];
    
    resultArray = [self.database recentComment];
    
    dateArray = resultArray[0];
    commentArray = resultArray[1];
    
    int i;
    for (i=0; i<[commentArray count]; i++) {
        NSLog(@"comment=%@",[[commentArray objectAtIndex:i] description]);
        NSLog(@"date=%@",[[dateArray objectAtIndex:i] description]);
    }
    
}
//
//
////直近のコメントを
//- (void)recentComment{
//    
//}



//- (void)searchResult{
//    
//    
//    
//    
//    
//    
//    //聖書ラベルの作成
//    int i;
//    for (i=0; i<[idArray count]; i++) {
//        
//        CGRect bibleNameRect = CGRectMake(width/9, 50+i*height/12, width-40, 30);
//        UILabel *bibleLabel = [[UILabel alloc]initWithFrame:bibleNameRect];
//        if ([countryCode isEqualToString: countryCodeEn]) {
//            bibleLabel.text = [bibleName objectAtIndex:i];
//            NSLog(@"countryCodeEn=%@",countryCodeEn);
//        }else if([countryCode isEqualToString: countryCodeJa]){
//            bibleLabel.text = [bibleNameJp objectAtIndex:i];
//            NSLog(@"countryCodeJa=%@",countryCodeJa);
//        }else if([countryCode isEqualToString: countryCodeCn]){
//            bibleLabel.text = [bibleNameCn objectAtIndex:i];
//            NSLog(@"countryCodeCn=%@",countryCodeCn);
//        }
//        bibleLabel.textColor = [UIColor blackColor];
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//            bibleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
//        }else{
//            bibleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
//        }
//        [scrollAllView addSubview:bibleLabel];
//        
//    }
//    
//    //章ラベルの作成
//    for (i=0; i<[idArray count]; i++) {
//        
//        //章があるところだけラベル表示する
//        if (![[capter objectAtIndex:i]intValue]==0) {
//            CGRect chapterRect = CGRectMake(width/9*4, 50+i*height/12, width-40, 30);
//            UILabel *chaperLabel = [[UILabel alloc]initWithFrame:chapterRect];
//            chaperLabel.text = [NSString stringWithFormat:@"%d",[[capter objectAtIndex:i]integerValue]];
//            chaperLabel.textColor = [UIColor blackColor];
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//                chaperLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
//            }else{
//                chaperLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
//            }
//            [scrollAllView addSubview:chaperLabel];
//        }
//    }
//    
//    //節ラベルの作成
//    for (i=0; i<[idArray count]; i++) {
//        
//        NSString *verseString = [verse objectAtIndex:i];
//        //節情報があるところだけラベル表示する
//        if ([verseString length]>1) {
//            CGRect verseRect = CGRectMake(width/9*5, 50+i*height/12, width-40, 30);
//            UILabel *verseLabel = [[UILabel alloc]initWithFrame:verseRect];
//            verseLabel.text = [NSString stringWithFormat:@": %@",[verse objectAtIndex:i]];
//            verseLabel.textColor = [UIColor blackColor];
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//                verseLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
//            }else{
//                verseLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
//            }
//            [scrollAllView addSubview:verseLabel];
//        }
//        
//    }
//    
//    
//    //コメント欄作成
//    //なぜかviewcontrollerが呼ばれる時にこのコードが読まれるらしいので、myReadingTableがある場合のみ呼ばれるようにした。
//    BOOL exist = [self.database existDataFolderOrNot];
//    if (exist) {
//        CGRect textRect;
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//            textRect = CGRectMake(width/9, 50+10*height/12, width-40, 15);
//        }else{
//            textRect = CGRectMake(width/9, 50+10*height/12, width-40, 30);
//        }
//        textfield = [[UITextField alloc]initWithFrame:textRect];
//        if ([[comment objectAtIndex:0] isEqualToString:@" "]) {
//            textfield.placeholder = @"comment";
//        }else{
//            textfield.text = [comment objectAtIndex:0] ;
//        }
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//            textfield.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
//        }else{
//            textfield.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
//        }
//        textfield.returnKeyType = UIReturnKeyDefault;
//        textfield.delegate = self;
//        [scrollAllView addSubview:textfield];
//        [self registerForKeyboardNotifications];
//    }
//}


////Viewがロードされるタイミングで呼ばれる関数
//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//}
//
//
////キーボード表示関数
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    CGPoint scrollPoint = CGPointMake(0.0,200.0);
//    [scrollAllView setContentOffset:scrollPoint animated:YES];
//}
//
//
////キーボードを隠す関数
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    [scrollAllView setContentOffset:CGPointZero animated:YES];
//}
//
//
////textfieldでリターンキーが押されるとキーボードを隠し、コメントをDBに保存する。
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self.database updateComment:intDate TEXT:textField.text];
//    [textField resignFirstResponder];
//    return YES;
//}







@end

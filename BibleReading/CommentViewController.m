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
    UILabel *dateLabel;
    UILabel *commentLabel;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;


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
    [self selectedDate];
    [self createLabel];
    [self setSideBar];
    
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
    
    //バックの色をfloralwhiteに設定
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.98 blue:0.941 alpha:1];
    
    //全体にUIScrollviewを作成
    scrollAllView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    scrollAllView.delegate = self;
    scrollAllView.scrollEnabled = YES;
    scrollAllView.showsHorizontalScrollIndicator = NO;
    scrollAllView.showsVerticalScrollIndicator = NO;
    scrollAllView.scrollsToTop =YES;
    scrollAllView.userInteractionEnabled = YES;
    [scrollAllView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //コメント検索欄を作成
    CGRect searchRect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        searchRect = CGRectMake(width/9, 100, width-40, 15);
    }else{
        searchRect = CGRectMake(width/9, 100, width-40, 30);
    }
    textfield = [[UITextField alloc]initWithFrame:searchRect];
    textfield.placeholder = @"searchComment";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        textfield.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
    }else{
        textfield.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
    }
    textfield.returnKeyType = UIReturnKeyDefault;
    textfield.delegate = self;
    [scrollAllView addSubview:textfield];
    [self registerForKeyboardNotifications];
    
    [self.view addSubview:scrollAllView];
}


//ラベル作成
- (void)createLabel{
    CGRect dateRect;
    CGRect commentRect;
    int i;
    if (!([dateArray count]==0)) {
        for (i = 0; i < [dateArray count]; i++) {
            NSLog(@"dateArrayCount=%d",[dateArray count]);
            NSLog(@"i=%d",i);
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                dateRect = CGRectMake(width/9, 150+i*height/12, width-40, 15);
                commentRect = CGRectMake(width/9, 170+i*height/12, width-40, 15);
            }else{
                dateRect = CGRectMake(width/9, 150+i*height/12, width-40, 30);
                commentRect = CGRectMake(width/9, 180+i*height/12, width-40, 30);
            }
            
            dateLabel = [[UILabel alloc]initWithFrame:dateRect];
            commentLabel = [[UILabel alloc]initWithFrame:commentRect];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                dateLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
                commentLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
            }else{
                dateLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
                commentLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:30];
            }
            
            dateLabel.text = [NSString stringWithFormat:@"%d",[[dateArray objectAtIndex:i]integerValue]];
            NSLog(@"dateLabel=%@",dateLabel.text);
            commentLabel.text = [commentArray objectAtIndex:i] ;
            [scrollAllView addSubview:dateLabel];
            [scrollAllView addSubview:commentLabel];
            [scrollAllView setContentSize:CGSizeMake(width, 200+i*height/12)];
        }
    }
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

}


//コメント検索を読み込む
- (void)searchCommentResult:(NSString *)TEXT{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];
    commentArray = [[NSMutableArray alloc]init];
    
    resultArray = [self.database searchComment:TEXT];
    
    dateArray = resultArray[0];
    commentArray = resultArray[1];
    
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
    CGPoint scrollPoint = CGPointMake(0.0,0.0);
    [scrollAllView setContentOffset:scrollPoint animated:YES];
}


//キーボードを隠す関数
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [scrollAllView setContentOffset:CGPointZero animated:YES];
}


//textfieldでリターンキーが押されるとキーボードを隠し、コメントをDBに保存する。
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchCommentResult:textfield.text];
    //現在のラベルを削除する
    for (UIView *v in [scrollAllView subviews]) {
            [v removeFromSuperview];
        }
    [self createsettingView];
    [self createLabel];
    [self setSideBar];
    [textField resignFirstResponder];
    return YES;
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

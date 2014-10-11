//
//  ViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController (){
    UIButton *listBtn;
    UIWebView *youtubeView;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *planView;
@property RDVCalendarView *calendar;

@end



@implementation CalendarViewController

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
    [self firstLoad];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstLoad{
    
    self.calendar = [[RDVCalendarView alloc]init];
    self.calendar.delegate = self;
    
    [self setSideBar];
    [self buttonToRead];
    [self checkFirst];

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
    _planView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,50)];
    [self.view addSubview:_planView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIImage *img = [UIImage imageNamed:@"list_tk.png"];
    listBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(15, 25, 32, 32)];
    [listBtn setBackgroundImage:img forState:UIControlStateNormal];
    [listBtn addTarget:self
                action:@selector(viewListMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_planView addSubview:listBtn];
    
    //バックの色をfloralwhiteに設定
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.98 blue:0.941 alpha:1];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            [self setSideBar];
            break;
        case 1:
            [self performSegueWithIdentifier:@"calendarToSetting" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"calendarToView" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"calendarToComment" sender:self];
            break;
    }
}


- (void)checkFirst{
    
    self.database = [[DataBase alloc]init];
    BOOL exist = [self.database existDataFolderOrNot];
     
    if (!exist) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Would you like to see operating instructions movie?", nil)
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               otherButtonTitles:@"OK",nil];
         [alert show];
     }
    
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            
        case 0:
            break;
        
        case 1:
            youtubeView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            youtubeView.delegate = self;
            youtubeView.scalesPageToFit = YES;
            [BNIndicator showForView:youtubeView withMessage:@"Loading"];
            NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/embed/SGc2S87uPp4?feature=player_detailpage&rel=0"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [youtubeView loadRequest:request];
            
            [self.view addSubview:youtubeView];
            
            //戻るボタンの作成
            UIButton *backCalender = [[UIButton alloc]
                            initWithFrame:CGRectMake(0, 25, 100, 32)];
            [backCalender setTitle:NSLocalizedString(@"toCalender", nil) forState:UIControlStateNormal];
            [backCalender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [backCalender.titleLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:15]];
            [backCalender addTarget:self
                             action:@selector(deleteWebView:) forControlEvents:UIControlEventTouchUpInside];
            [youtubeView addSubview:backCalender];
            break;
    }
}


// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [BNIndicator hideForView:youtubeView];
}


//webView削除
- (IBAction)deleteWebView:(id)sender{
    [youtubeView removeFromSuperview];
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


//デリゲートメソッド
- (void)buttonToRead{
    [self performSegueWithIdentifier:@"calendarToRead" sender:self];    
}


@end

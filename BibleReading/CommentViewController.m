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
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property UIView *planView;

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


@end

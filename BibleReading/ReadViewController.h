//
//  ReadViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "BNIndicator.h"
#import "BNIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@interface ReadViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>

@property DataBase *database;


@end

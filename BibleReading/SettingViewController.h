//
//  SettingViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "DataBase.h"

@interface SettingViewController : UIViewController<RNFrostedSidebarDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property DataBase *database;

@end

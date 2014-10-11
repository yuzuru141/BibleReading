//
//  CommentViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/10/11.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "DataBase.h"


@interface CommentViewController : UIViewController<RNFrostedSidebarDelegate>

@property DataBase *database;


@end

//
//  ViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface DataBase : NSObject

- (void)createDB;
- (void)readDB:(NSString*)argument1;
- (void)selectPlan:(int)year label:(int)plan;


@end

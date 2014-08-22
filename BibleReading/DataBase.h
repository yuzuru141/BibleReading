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
//- (void)readDB:(NSString*)argument1;
- (NSMutableArray *)selectPlan:(int)year label:(int)plan;
- (void)createTable;
- (void)deleteDataInTable;
- (void)insertTable:(int)ID label1:(NSString*)BIBBLE_NAME label2:(NSString*)BIBBLE_NAME_JAPANESE label3:(NSString*)BIBBLE_NAME_CHINESE label4:(int)CAPTER label5:(NSString*)VERSE label6:(NSDate*)DATE;
- (NSMutableArray*)dbLoadByDate:(int)DATE;
- (void)dbUpdateReadOrNot:(int)ID;
- (void)dbDeleteReadOrNot:(int)ID;
- (NSMutableArray*)dbLoadReadOrNot:(int)ID;

//一時的な関数
//- (void)overWrite;

@end

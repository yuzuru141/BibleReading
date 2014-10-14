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

- (BOOL)existDataFolderOrNot;
- (void)createDB;
- (NSMutableArray *)selectPlan:(NSInteger)year label:(NSInteger)plan;
- (void)createTable;
- (void)deleteDataInTable;
- (void)insertTable:(int)ID label1:(NSString*)BIBBLE_NAME label2:(NSString*)BIBBLE_NAME_JAPANESE label3:(NSString*)BIBBLE_NAME_CHINESE label4:(int)CAPTER label5:(NSString*)VERSE label6:(NSDate*)DATE;
- (NSMutableArray*)dbLoadByDate:(NSInteger)DATE;
- (void)dbUpdateReadOrNot:(int)ID;
- (void)dbDeleteReadOrNot:(int)ID;
- (NSMutableArray*)dbLoadReadOrNot:(int)ID;
- (void)updateComment:(NSInteger)DATE TEXT:(NSString *)comment;
- (NSMutableArray*)checkDate:(int)DATE;
- (NSMutableArray *)recentComment;
- (NSMutableArray *)searchComment:(NSString *)WORD;

@end

//
//  ViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "DataBase.h"
@interface DataBase()
@end

@implementation DataBase{
    
}

//全く新規でDatafolderがあるかないか確認する
- (BOOL)existDataFolderOrNot{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *baseDir = [self dataFolderPath];
    
    BOOL exists = [fileManager fileExistsAtPath:baseDir];
    return exists;
}


//DB作成
- (void)createDB{
    
    //データ保存用のディレクトリを作成する
    if ([self makeDirForAppContents]) {
        //ディレクトリに対して「do not backup」属性をセット
        NSURL *dirUrl = [NSURL fileURLWithPath: [self dataFolderPath]];
        [self addSkipBackupAttributeToItemAtURL:dirUrl];
    }
    
    NSString *dbPath = [self connectDB];
    NSLog(@"db path = %@", dbPath);
    
    BOOL checkDb;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbfile = @"Bibile_Read_BaseDB.db";
    
    // データベースファイルを確認
    checkDb = [fileManager fileExistsAtPath:dbPath];
    if(!checkDb){
        // ファイルが無い場合はコピー
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbfile];
        checkDb = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if(!checkDb){
            // error
            NSLog(@"error=%@",error);
            NSLog(@"Copy error = %@", defaultDBPath);
        }
    }
    else{
        NSLog((@"DB file OK"));
    }
    
}



//聖書通読プランを選択する
- (NSMutableArray *)selectPlan:(NSInteger)year label:(NSInteger)plan{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    NSString *selectSql;
    
    switch (plan) {
            //プランをgeneralに選択した場合
        case 0:
            switch (year) {
                    //1yearに選択した場合
                case 0:
                    selectSql = @"select * from baseTable order by general, one_year_group asc, id asc";
                    break;
                    //2yearに選択した場合
                case 1:
                    selectSql = @"select * from baseTable order by general, two_year_group asc, id asc";
                    break;
                default:
                    selectSql = @"select * from baseTable order by general, id asc";
                    break;
            }
            break;
            //プランをtime_orderingに選択した場合
        case 1:
            switch (year) {
                    //1yearに選択した場合
                case 0:
                    selectSql = @"select * from baseTable order by time_ordering asc, one_year_group asc, id asc";
                    break;
                    //2yearに選択した場合
                case 1:
                    selectSql = @"select * from baseTable order by time_ordering asc, two_year_group asc, id asc";
                    break;
                default:
                    selectSql = @"select * from baseTable order by time_ordering asc, id asc";
                    break;
            }
            break;
            //プランをrecommendに選択した場合
        case 2:
            switch (year) {
                    //1yearに選択した場合
                case 0:
                    selectSql = @"select * from baseTable order by recommend asc, one_year_group asc, id asc";
                    break;
                    //2yearに選択した場合
                case 1:
                    selectSql = @"select * from baseTable order by recommend asc, two_year_group asc, id asc";
                    break;
                default:
                    selectSql = @"select * from baseTable order by recommend asc, id asc";
                    break;
            }
            break;
        default:
            break;
    }
    
    //容れ物の準備
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    //要素のいれものをつくる
    NSMutableArray *idArray = [[NSMutableArray alloc]init];
    NSMutableArray *bibleName = [[NSMutableArray alloc]init];
    NSMutableArray *bibleNameJp = [[NSMutableArray alloc]init];
    NSMutableArray *bibleNameCn = [[NSMutableArray alloc]init];
    NSMutableArray *oneYearGroup = [[NSMutableArray alloc]init];
    NSMutableArray *twoYearGroup = [[NSMutableArray alloc]init];
    NSMutableArray *general = [[NSMutableArray alloc]init];
    NSMutableArray *capter = [[NSMutableArray alloc]init];
    NSMutableArray *verse = [[NSMutableArray alloc]init];
    
    FMResultSet *result = [db executeQuery:selectSql];
    while ( [result next] ) {
        
        int rId   = [result intForColumn:@"id"];
        [idArray addObject:[NSNumber numberWithInteger:rId]];
        
        NSString *rName = [result stringForColumn:@"bible_name"];
        [bibleName addObject:rName];
        
        NSString *rNameJp = [result stringForColumn:@"bible_name_japanese"];
        [bibleNameJp addObject:rNameJp];
        
        NSString *rNameCn = [result stringForColumn:@"bible_chinese"];
        [bibleNameCn addObject:rNameCn];
        
        int rOneYearGroup = [result intForColumn:@"one_year_group"];
        [oneYearGroup addObject:[NSNumber numberWithInteger:rOneYearGroup]];
        
        int rTwoYearGroup = [result intForColumn:@"two_year_group"];
        [twoYearGroup addObject:[NSNumber numberWithInteger:rTwoYearGroup]];
        
        int rGeneral = [result intForColumn:@"general"];
        [general addObject:[NSNumber numberWithInteger:rGeneral]];
        
        int rCapter = [result intForColumn:@"capter"];
        [capter addObject:[NSNumber numberWithInteger:rCapter]];
        
        NSString *rVerse = [result stringForColumn:@"verse"];
        [verse addObject:rVerse];
        
    }
    [db close];
    
    [resultArray addObject:idArray];
    [resultArray addObject:bibleName];
    [resultArray addObject:bibleNameJp];
    [resultArray addObject:bibleNameCn];
    [resultArray addObject:oneYearGroup];
    [resultArray addObject:twoYearGroup];
    [resultArray addObject:general];
    [resultArray addObject:capter];
    [resultArray addObject:verse];
    
    return resultArray;
}


//聖書通読用のテーブル作成
- (void)createTable{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS myReadingTable(id INTEGER, bible_name TEXT, bible_name_japanese TEXT, bible_chinese TEXT, capter INTEGER, verse TEXT, date INTEGER, readOrNot INTEGER, comment TEXT);";
    
    [db executeUpdate:sql];
    
    [db close];
}


//初期値を投入する前にDataを削除する
- (void)deleteDataInTable{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    NSString *sql = @"DELETE FROM myReadingTable";
    
    [db executeUpdate:sql];
    
    [db close];
}


//聖書通読用のテーブルに初期値を投入
- (void)insertTable:(int)ID label1:(NSString*)BIBBLE_NAME label2:(NSString*)BIBBLE_NAME_JAPANESE label3:(NSString*)BIBBLE_NAME_CHINESE label4:(int)CAPTER label5:(NSString*)VERSE label6:(NSDate*)DATE{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [formatter setDateFormat:@"yyyyMMdd"];
    int dateInt = [formatter stringFromDate:DATE].intValue;
    NSLog(@"dateInt=%d",dateInt);
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    NSString *insert_sql = @"INSERT INTO myReadingTable(id, bible_name, bible_name_japanese, bible_chinese, capter, verse, date, readOrNot,comment) VALUES (?,?,?,?,?,?,?,?,?)";
    
    [db executeUpdate:insert_sql ,
     [NSNumber numberWithInteger:ID],
     BIBBLE_NAME,
     BIBBLE_NAME_JAPANESE,
     BIBBLE_NAME_CHINESE,
     [NSNumber numberWithDouble:CAPTER],
     VERSE,
     [NSNumber numberWithInteger:dateInt] ,
     //読んでいないのでreadOrNotの初期値は0
     [NSNumber numberWithInteger:0],
     @" "];
    
    [db close];
}


//日付からDBを読み込む
- (NSMutableArray*)dbLoadByDate:(NSInteger)DATE{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *idArray = [[NSMutableArray alloc]init];
    NSMutableArray *bibleName = [[NSMutableArray alloc]init];
    NSMutableArray *bibleNameJp = [[NSMutableArray alloc]init];
    NSMutableArray *bibleNameCn = [[NSMutableArray alloc]init];
    NSMutableArray *capter = [[NSMutableArray alloc]init];
    NSMutableArray *verse = [[NSMutableArray alloc]init];
    NSMutableArray *readOrNot = [[NSMutableArray alloc]init];
    NSMutableArray *comment = [[NSMutableArray alloc]init];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from myReadingTable where date = %ld",(long)DATE];
    FMResultSet *result = [db executeQuery:sql];
    
    while ([result next]) {
        
        int rId   = [result intForColumn:@"id"];
        [idArray addObject:[NSNumber numberWithInteger:rId]];
        
        NSString *rName = [result stringForColumn:@"bible_name"];
        [bibleName addObject:rName];
        
        NSString *rNameJp = [result stringForColumn:@"bible_name_japanese"];
        [bibleNameJp addObject:rNameJp];
        
        NSString *rNameCn = [result stringForColumn:@"bible_chinese"];
        [bibleNameCn addObject:rNameCn];
        
        int rCapter = [result intForColumn:@"capter"];
        [capter addObject:[NSNumber numberWithInteger:rCapter]];
        
        NSString *rVerse = [result stringForColumn:@"verse"];
        [verse addObject:rVerse];
        
        int rReadOrNot = [result intForColumn:@"readOrNot"];
        [readOrNot addObject:[NSNumber numberWithInteger:rReadOrNot]];
        
        NSString *rComment = [result stringForColumn:@"comment"];
        [comment addObject:rComment];
    }
    
    [db close];
    
    [resultArray addObject:idArray];
    [resultArray addObject:bibleName];
    [resultArray addObject:bibleNameJp];
    [resultArray addObject:bibleNameCn];
    [resultArray addObject:capter];
    [resultArray addObject:verse];
    [resultArray addObject:readOrNot];
    [resultArray addObject:comment];
    
    return resultArray;
}


//DBへ読んだ情報をアップデート
- (void)dbUpdateReadOrNot:(int)ID{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSString *update_readOrNot = [NSString stringWithFormat:@"update myReadingTable set readOrNot =1 where id = %d",ID];
    
    [db open];
    [db executeUpdate:update_readOrNot];
    [db close];
    
    NSLog(@"readOrNotアップデートされました");
}

//DBへ読んでいない情報へアップデート
- (void)dbDeleteReadOrNot:(int)ID{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSString *update_readOrNot = [NSString stringWithFormat:@"update myReadingTable set readOrNot =0 where id = %d",ID];
    
    [db open];
    [db executeUpdate:update_readOrNot];
    [db close];
    
    NSLog(@"readOrNotデリートされました");
}


//個別のReadOrNotをアップデート
- (NSMutableArray*)dbLoadReadOrNot:(int)ID{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSLog(@"ID=%d",ID);
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *readOrNot = [[NSMutableArray alloc]init];
    
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from myReadingTable where id = %d",ID];
    FMResultSet *result = [db executeQuery:sql];
    
    while ([result next]) {
        
        int rReadOrNot = [result intForColumn:@"readOrNot"];
        [readOrNot addObject:[NSNumber numberWithInteger:rReadOrNot]];
    }
    
    [db close];
    [resultArray addObject:readOrNot];
    NSLog(@"readOrNot=%d",[[readOrNot objectAtIndex:0]intValue]);
    return resultArray;
}


//コメントを書いた時に使う関数
- (void)updateComment:(NSInteger)DATE TEXT:(NSString *)comment{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    NSString *update_commentText;
    
    //コメントにシングルクオーテーションが含まれるか確認する。
    NSRange searchResult = [comment rangeOfString:@"'"];
    if(searchResult.location == NSNotFound){
        update_commentText = [NSString stringWithFormat:@"update myReadingTable set comment = '%@' where date = %ld",comment, (long)DATE];
    }else{
        // みつかった場合の処理
        NSInteger characterSum = [comment length];
        for (int i=0; i<characterSum; i++) {
            NSString *search = [comment substringWithRange:NSMakeRange(i,1)];
            if ([search isEqualToString:@"'"]) {
                NSString *front = [comment substringToIndex:i+1];
                NSString *back = [comment substringFromIndex:i+1];
                //もう一回検索をかける
//                NSRange searchResult2 = [back rangeOfString:@"'"];
//                if (!(searchResult2.location == NSNotFound)) {
//                for (int j=0; j<[back length]; j++) {
//                    NSString *search2 = [back substringWithRange:NSMakeRange(j,1)];
//                    if ([search2 isEqualToString:@"'"]) {
//                        NSString *front2 = [back substringToIndex:j+1];
//                        NSString *back2 = [back substringFromIndex:j+1];
//                        NSString *unionComment2 = [NSString stringWithFormat:@"%@'%@'%@",front,front2,back2];
//                        NSLog(@"unionComment2=%@",unionComment2);
//                        update_commentText = [NSString stringWithFormat:@"update myReadingTable set comment = '%@' where date = %ld",unionComment2, (long)DATE];
//                    }
//                }
//                }else{
                    NSString *unionComment = [NSString stringWithFormat:@"%@'%@",front,back];
                    update_commentText = [NSString stringWithFormat:@"update myReadingTable set comment = '%@' where date = %ld",unionComment, (long)DATE];
                    NSLog(@"update_commentText=%@",update_commentText);
//                }
//
            }
        }
    }
    [db open];
    [db executeUpdate:update_commentText];
    [db close];
}


//プランの章を全て読み終わった日付を確認する
- (NSMutableArray*)checkDate:(int)DATE{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *readOrNotArray = [[NSMutableArray alloc]init];
    
    NSString *selectDate = [NSString stringWithFormat:@"select * from myReadingTable where date = %d",DATE];
    NSLog(@"selectDate=%@",selectDate);
    
    [db open];
    FMResultSet *result = [[FMResultSet alloc]init];
    result = [db executeQuery:selectDate];
    
    
    int rReadOrNot;
    
    while ([result next]) {
        rReadOrNot = [result intForColumn:@"readOrNot"];
        [readOrNotArray addObject:[NSNumber numberWithInteger:rReadOrNot]];
//        int rDate= [result intForColumn:@"date"];
//        NSLog(@"rDate=%d",rDate);
    }
    [db close];
    [resultArray addObject:readOrNotArray];
    return resultArray;
}


//直近のコメントを返す
- (NSMutableArray *)recentComment{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [formatter setDateFormat:@"yyyyMMdd"];
    int dateInt = [formatter stringFromDate:[NSDate date]].intValue;
    int rId = 0;
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *dateArray = [[NSMutableArray alloc]init];
    NSMutableArray *comment = [[NSMutableArray alloc]init];
    
    FMResultSet *resultToday = [[FMResultSet alloc]init];
    
    [db open];
    
    //最初にForをスタートさせる日付を取得
    NSString *todayId = [NSString stringWithFormat:@"select * from myReadingTable where date = %d",dateInt];
    resultToday = [db executeQuery:todayId];
    while ([resultToday next]) {
        rId   = [resultToday intForColumn:@"id"];
        break;
    }
    
    //コメントと日付を取得していく
    FMResultSet *result = [[FMResultSet alloc]init];
    int rDate=0;
    int rDateNext=0;
    for (int i=rId; i>=0; i--) {
        NSString *recentCommentText = [NSString stringWithFormat:@"select * from myReadingTable where id = %d",rId];
        result = [db executeQuery:recentCommentText];
        while ([result next]) {
            NSString *rComment = [result stringForColumn:@"comment"];
            if (![rComment isEqualToString:@" "]) {
                rDate= [result intForColumn:@"date"];
                if (!(rDate==rDateNext)) {
                    [dateArray addObject:[NSNumber numberWithInteger:rDate]];
                    [comment addObject:rComment];
                    rDateNext = rDate;
                }
            }
        }
        rId--;
//        //コメントを取得する件数を５件までにする
//        if ([comment count]==5) {
//            break;
//        }
    }
    
    [db close];
    [resultArray addObject:dateArray];
    [resultArray addObject:comment];
    return resultArray;
}


//コメント検索
- (NSMutableArray *)searchComment:(NSString *)WORD{
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *dateArray = [[NSMutableArray alloc]init];
    NSMutableArray *commentArray = [[NSMutableArray alloc]init];
    int rDate = 0;
    int rDateNext = 0;
    NSString *rComment;
    NSString *commentSearch;
    
    FMResultSet *resultComment = [[FMResultSet alloc]init];
    
    //検索ワードにシングルクオーテーションが含まれるか確認する。
    NSRange searchResult = [WORD rangeOfString:@"'"];
    if(searchResult.location == NSNotFound){
        commentSearch = [NSString stringWithFormat:@"select * from myReadingTable where comment like '%%%@%%';",WORD];
    }else{
        // みつかった場合の処理
        NSInteger characterSum = [WORD length];
        for (int i=0; i<characterSum; i++) {
            NSString *search = [WORD substringWithRange:NSMakeRange(i,1)];
            if ([search isEqualToString:@"'"]) {
                NSString *front = [WORD substringToIndex:i+1];
                NSString *back = [WORD substringFromIndex:i+1];
                NSString *unionComment = [NSString stringWithFormat:@"%@'%@",front,back];
                commentSearch = [NSString stringWithFormat:@"select * from myReadingTable where comment like '%%%@%%';",unionComment];
                NSLog(@"update_commentText=%@",commentSearch);
            }
        }
    }
    
    [db open];
    
    resultComment = [db executeQuery:commentSearch];
    while ([resultComment next]) {
        rDate = [resultComment intForColumn:@"date"];
        
        if (!(rDate==rDateNext)) {
            [dateArray addObject:[NSNumber numberWithInteger:rDate]];
            NSLog(@"rDate=%d",rDate);
            rComment   = [resultComment stringForColumn:@"comment"];
            [commentArray addObject:rComment];
            NSLog(@"rComment=%@",rComment);
            rDateNext = rDate;
        }
    }
    [db close];
    [resultArray addObject:dateArray];
    [resultArray addObject:commentArray];
    return resultArray;

}



//DB接続
- (NSString *)connectDB{
    
    NSString *dbfile = @"Bibile_Read_BaseDB.db";
    NSString *dbPath = [[self dataFolderPath] stringByAppendingPathComponent:dbfile];
    return dbPath;
    
}


//DB削除メソッド。必要な時以外、絶対に使用しないこと！！
- (void)dbDelete{
    
    //DB接続
    NSString *databaseFilePath = [[self dataFolderPath] stringByAppendingPathComponent:@"Bibile_Read_BaseDB.db"];
    
    //削除
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:databaseFilePath error:nil];
    NSLog(@"delete db_file");
    
    
}



//DocumentsフォルダにDB用のフォルダを作成する関数
- (BOOL)makeDirForAppContents
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *baseDir = [self dataFolderPath];
    
    BOOL exists = [fileManager fileExistsAtPath:baseDir];
    if (!exists) {
        NSError *error;
        BOOL created = [fileManager createDirectoryAtPath:baseDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created) {
            NSLog(@"ディレクトリ作成失敗");
            return NO;
        }
    } else {
        //作成済みの場合はNO
        return NO;
    }
    return YES;
}


//データ保存用のフォルダのパスを返す関数
- (NSString *)dataFolderPath
{
    //アプリのドキュメントフォルダのパスを検索
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //追加するディレクトリ名を指定
    NSString *dataFolderPath = [documentsPath stringByAppendingPathComponent:@"DataFolder"];
    //    NSLog(@"dataFolderPass=%@",dataFolderPath);
    return dataFolderPath;
}


//iCloudへのバックアップを行なわないようにする関数
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}



@end

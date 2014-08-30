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

//- (void)readDB:(NSString*)argument1{
//    
//    NSString *dbPath = [self connectDB];
//    
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    
//    [db open];
//    
//    // list up
//    NSString *selectSql = [NSString stringWithFormat:@"SELECT id, %@ FROM baseTable;",argument1];
//    FMResultSet *result = [db executeQuery:selectSql];
//    while ( [result next] ) {
//        NSString *rId   = [result stringForColumn:@"id"];
//        NSString *rArg = [result stringForColumn:[NSString stringWithFormat:@"%@",argument1]];
//        NSLog(@"%@, %@", rId , rArg);
//    }
//    [db close];
//}


//聖書通読プランを選択する
- (NSMutableArray *)selectPlan:(int)year label:(int)plan{
    
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

    NSString *sql = @"CREATE TABLE IF NOT EXISTS myReadingTable(id INTEGER, bible_name TEXT, bible_name_japanese TEXT, bible_chinese TEXT, capter INTEGER, verse TEXT, date INTEGER, readOrNot INTEGER);";
    
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
    
    //日付をint型に変換
    NSString* date_str;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    date_str = [formatter stringFromDate:DATE]; //strに変換
    int dateInt = [date_str integerValue];
//    NSLog(@"dateInt=%d",dateInt);
//    NSLog(@"chapter=%d",CAPTER);
    
    NSString *dbPath = [self connectDB];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    NSString *insert_sql = @"INSERT INTO myReadingTable(id, bible_name, bible_name_japanese, bible_chinese, capter, verse, date, readOrNot) VALUES (?,?,?,?,?,?,?,?)";
    
    [db executeUpdate:insert_sql ,
     [NSNumber numberWithInteger:ID],
     BIBBLE_NAME,
     BIBBLE_NAME_JAPANESE,
     BIBBLE_NAME_CHINESE,
     [NSNumber numberWithDouble:CAPTER],
     VERSE,
     [NSNumber numberWithInteger:dateInt] ,
     //読んでいないのでreadOrNotの初期値は0
     [NSNumber numberWithInteger:0]];
    [db close];
}

//日付からDBを読み込む
- (NSMutableArray*)dbLoadByDate:(int)DATE{
    
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

    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"select * from myReadingTable where date = %d",DATE];
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
//        NSLog(@"rChapter=%d",rCapter);
        
        NSString *rVerse = [result stringForColumn:@"verse"];
        [verse addObject:rVerse];

        int rReadOrNot = [result intForColumn:@"readOrNot"];
        [readOrNot addObject:[NSNumber numberWithInteger:rReadOrNot]];
    }
    
    [db close];

    [resultArray addObject:idArray];
    [resultArray addObject:bibleName];
    [resultArray addObject:bibleNameJp];
    [resultArray addObject:bibleNameCn];
    [resultArray addObject:capter];
    [resultArray addObject:verse];
    [resultArray addObject:readOrNot];
    
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



//DB接続
- (NSString *)connectDB{

    NSString *dbfile = @"Bibile_Read_BaseDB.db";
    NSString *dbPath = [[self dataFolderPath] stringByAppendingPathComponent:dbfile];
    return dbPath;

}


//DB削除メソッド。必要な時以外、絶対に使用しないこと！！（石井）
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
//
//
//- (void)overWrite{
//    NSString *dbPath = [self connectDB];
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    
//    [db open];
//    
//    NSString *sql = [NSString stringWithFormat:@"select * from baseTable where bible_name_japanese = 'ヨシュア'"];
////     NSString *sql = [NSString stringWithFormat:@"update baseTable set bible_name_japanese = 'ヨシュア' where bible_name_japanese = 'ヨシュア記'"];
////         NSString *sql = [NSString stringWithFormat:@"update baseTable set bible_name_japanese = 'ヨシュア' where id = 192"];
//    FMResultSet *result = [db executeQuery:sql];
//    
//    while ([result next]) {
//        NSLog(@"bible_name_japanese=%d",[result intForColumn:@"id"]);
////        NSLog(@"bible_name_japanese=%@",[result stringForColumn:@"bible_name_japanese"]);
//    }
//    
//    [db close];
//    return;
//}


@end

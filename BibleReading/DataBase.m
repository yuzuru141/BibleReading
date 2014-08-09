//
//  ViewController.h
//  BibleReading
//
//  Created by 石井嗣 on 2014/07/19.
//  Copyright (c) 2014年 YuZ. All rights reserved.
//

#import "DataBase.h"
@interface DataBase()
@property NSInteger dataid;
@property int dataCount;
@end

@implementation DataBase{

//    FMDatabase *database;
//    int dataid;
    NSString *addressStr;

}


//- (void)makeDatabase{
//
//    
//    //データ保存用のディレクトリを作成する
//    if ([self makeDirForAppContents]) {
//        //ディレクトリに対して「do not backup」属性をセット
//        NSURL *dirUrl = [NSURL fileURLWithPath: [self dataFolderPath]];
//        [self addSkipBackupAttributeToItemAtURL:dirUrl];
//    }
//    
//    //DB接続
//    NSString *databaseFilePath = [[self dataFolderPath] stringByAppendingPathComponent:@"Database.db"];
//    
//    //インスタンスの作成
//    FMDatabase *database = [FMDatabase databaseWithPath:databaseFilePath];
//    //データベースを開く
//    [database open];
//    
//    
//    /* テーブルの作成 */
//    NSString *sql = @"CREATE TABLE Bible_read_Table(id INTEGER PRIMARY KEY ,place_name TEXT,latitude REAL, longitude REAL , date INTEGER , picCount INTEGER,text TEXT ,pics TEXT ,went_flag INTEGER , delete_flag INTEGER , hour INTEGER , address TEXT);";
//
//    [database executeUpdate:sql];
//    
//    [database close];
//
//}

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

- (void)readDB:(NSString*)argument1{
    
    NSString *dbPath = [self connectDB];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    // list up
    NSString *selectSql = [NSString stringWithFormat:@"SELECT id, %@ FROM baseTable;",argument1];
    FMResultSet *result = [db executeQuery:selectSql];
    while ( [result next] ) {
        NSString *rId   = [result stringForColumn:@"id"];
        NSString *rArg = [result stringForColumn:[NSString stringWithFormat:@"%@",argument1]];
        NSLog(@"%@, %@", rId , rArg);
    }
    [db close];
}

-(NSMutableArray *)selectPlan:(int)year label:(int)plan{
    
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

        
//     NSLog(@"%d", rTwoYearGroup);
        
    }
    [db close];
    
    [resultArray addObject:idArray];
    [resultArray addObject:bibleName];
    [resultArray addObject:bibleNameJp];
    [resultArray addObject:bibleNameCn];
    [resultArray addObject:oneYearGroup];
    [resultArray addObject:twoYearGroup];
    [resultArray addObject:general];
    
    return resultArray;
}



////DBデータをIDの大きい順に配列に格納
//-(NSMutableArray *)loadDBData{
//    
////    //ディレクトリのリストを取得する
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSString *documentDirectry = paths[0];
////    NSString *databaseFilePath = [documentDirectry stringByAppendingPathComponent:@"Database.db"];
//    
//    //DB接続
//    NSString *databaseFilePath = [[self dataFolderPath] stringByAppendingPathComponent:@"Database.db"];
//
//    //データベース接続
//    FMDatabase *database = [FMDatabase databaseWithPath:databaseFilePath];
//
//    //容れ物の準備
//    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//    
//    //データベースを開く
//    [database open];
//    
//    //必要なデータを取り出す（ここでは、delete_flagが0のものすべて）    
//    //sqlのさいごにORDER BY ID DESC　をいれるとIDの順番でソートできる
//    
////    NSString *sql = @"SELECT * FROM testTable WHERE delete_flag = '0' ORDER BY date DESC;";
//    NSString *sql = @"SELECT * FROM testTable WHERE delete_flag = '0' ORDER BY ID DESC;";
//    
//    FMResultSet *results = [database executeQuery:sql];//DBの中身はresultsにはいるよ
//
//    //要素のいれものをつくる
//    NSMutableArray *idarray = [[NSMutableArray alloc]init];
//    NSMutableArray *titlearray = [[NSMutableArray alloc]init];
//    NSMutableArray *latarray = [[NSMutableArray alloc]init];
//    NSMutableArray *lonarray = [[NSMutableArray alloc]init];
//    NSMutableArray *datearray = [[NSMutableArray alloc]init];
//    NSMutableArray *textarray = [[NSMutableArray alloc]init];
//    NSMutableArray *picsarray = [[NSMutableArray alloc]init];//天気カラムを削除し、写真の枚数カラムを追加した（石井）
//    NSMutableArray *piccountarray = [[NSMutableArray alloc]init];
//    NSMutableArray *wentflagarray = [[NSMutableArray alloc]init];
//    NSMutableArray *hourarray = [[NSMutableArray alloc]init];
//    NSMutableArray *addressarray = [[NSMutableArray alloc]init];
//    
//
//    //データ取得を行うループ
//    while([results next]){ //結果が一行ずつ返されて、最後までいくとnextメソッドがnoを返す
//
//        int i = 0;
//        
//        //カラム名を指定して、カラム値を取得する。
//        int db_id = [results intForColumn:@"id"];
//        [idarray addObject:@(db_id)];
//        
//        NSString *db_title = [results stringForColumn:@"place_name"];
//        [titlearray addObject:db_title];
//        
//        double lat = [results doubleForColumn:@"latitude"];
//        [latarray addObject:@(lat)];
//        double lon = [results doubleForColumn:@"longitude"];
//        [lonarray addObject:@(lon)];
//        
//        int db_date = [results intForColumn:@"date"];
//        [datearray addObject:@(db_date)];
//        
//        NSString *db_text = [results stringForColumn:@"text"];
//        [textarray addObject:db_text];
//        
//        NSString *db_pics = [results stringForColumn:@"pics"];
//        [picsarray addObject:db_pics];
//        
//        int db_piccount = [results intForColumn:@"picCount"];//天気カラムを削除し、写真の枚数カラムを追加した（石井）
//        [piccountarray addObject:@(db_piccount)];
//        
//        int wentflag = [results intForColumn:@"went_flag"];
//        [wentflagarray addObject:@(wentflag)];
//        
//        int db_hour = [results intForColumn:@"hour"];
//        [hourarray addObject:@(db_hour)];
//        
//        NSString *db_address = [results stringForColumn:@"address"];
//        [addressarray addObject:db_address];
//
//        
//        //        int deleteflag = [results intForColumn:@"delete_flag"];
//        
//        /*
//        NSLog(@"check1 %d,%@,%f,%f,%@,%d,%@,%@,%d,%d,%@"
//              ,db_id,db_title,lat,lon,db_weather,db_date,db_text,db_pics,wentflag,db_hour,db_address
//              );//確認表示
//        */
//         //最終的にresltArrayに配列がそれぞれぼこっと入る感じで。
//        i++;
//
//    }
//    
//
//    [database close];
//
//    
//
//    
//    /* データ受け渡し用にぜんぶまとめてぶっこむ */
//
//    [resultArray addObject:idarray];//0
//    [resultArray addObject:titlearray];//1
//    [resultArray addObject:latarray];//2
//    [resultArray addObject:lonarray];//3
//    [resultArray addObject:datearray];//4
//    [resultArray addObject:textarray];//5
//    [resultArray addObject:picsarray];//6
//    [resultArray addObject:piccountarray];//7　天気カラムを削除し、写真の枚数カラムを追加した（石井）
//    [resultArray addObject:wentflagarray];//8
//    [resultArray addObject:hourarray]; //9
//    [resultArray addObject:addressarray]; //10
//    
////    NSLog(@"check3 ====%@",resultArray);
//    return resultArray;
//    
//
//}




//-(void)saveData{ //通しナンバーを保存
//
//    NSUserDefaults *savedata = [NSUserDefaults standardUserDefaults];
//    [savedata setInteger:_dataid forKey:@"dataid"];//INTEGER型
//    [savedata synchronize];
//
//}

//-(int)loadData{ //通しナンバーの読み込み
//    
//    NSUserDefaults *savedata = [NSUserDefaults standardUserDefaults];
//    _dataid = [savedata integerForKey:@"dataid"];
//    return  _dataid;
//}



//
////削除フラグ建てるメソッド
//- (void)DeleteFlag:(int)number{
//    
//    //DB接続
//    NSString *databaseFilePath = [[self dataFolderPath] stringByAppendingPathComponent:@"Database.db"];
//    FMDatabase *database = [FMDatabase databaseWithPath:databaseFilePath];
//    [database open];
//
//    
//    //データのupdate
//    NSString *update_sqlDeleteFlag = [NSString stringWithFormat:@"update testTable set delete_flag = 1 where id = %d",number];
//    
//    [database executeUpdate:update_sqlDeleteFlag];
//    [database close];
//        
//}






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
    NSLog(@"dataFolderPass=%@",dataFolderPath);
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

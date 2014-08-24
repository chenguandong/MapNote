//
//  SqlTools.m
//  Datastore Examples
//
//  Created by chenguandong on 14-5-22.
//
//

#import "SqlTools.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NoteBean.h"
@implementation SqlTools

+(void)getFMdatabase{
    
    NSLog(@"开始穿件表");
  

    NSFileManager * fileManager = [NSFileManager defaultManager];
    //if ([fileManager fileExistsAtPath:[self getdbPath]] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:[self getdbPath]];
        if ([db open]) {
            
            NSString * sql = @"CREATE TABLE IF NOT EXISTS notebook (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , note_title text,note_content text,note_time DATE,note_adress text,note_weather text,note_lat FLOAT,note_lng FLOAT)";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
                
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }

//}

+(NSString*)getdbPath{
    NSString *_docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_dbPath = [_docPath stringByAppendingPathComponent:@"notebook.db"];
   return  _dbPath;
}



+(NSArray*)queryData:(NSString*)sql{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];

    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[SqlTools getdbPath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        FMResultSet *rs = [db executeQuery:sql];//desc asc
        while ([rs next]) {
            
            NoteBean *noteBean = [[NoteBean alloc] init];
            noteBean.note_ID = [rs intForColumnIndex:0];
            noteBean.note_title = [rs stringForColumnIndex:1];
            noteBean.note_content = [rs stringForColumnIndex:2];
            noteBean.note_time = [rs dateForColumnIndex:3];
            noteBean.note_adress =[rs stringForColumnIndex:4];
            noteBean.note_weather = [rs stringForColumnIndex:5];
            noteBean.note_lat = [rs longForColumnIndex:6];
            noteBean.note_lng = [rs longForColumnIndex:7];
            
            [array addObject:noteBean];
        }
        
    }];
    
    
    NSLog(@"count=%d",array.count);
    return array;
}


@end

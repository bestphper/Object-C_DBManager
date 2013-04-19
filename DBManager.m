//
//  DBManager.m
//  Area
//
//  Created by huliang on 13-4-18.
//  Copyright (c) 2013年 huliang. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

// ----- copy DBFiel from bundle To Document  ----//
// -----If Update App and Already have some data in Document DB, you can use  execSql to Change DB Structure ----//

+(NSString *)copyFromBundleToDocument:(NSString *)fileName{
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: fileName]];
    
    NSFileManager *fmgr = [NSFileManager defaultManager];
    if(! [fmgr fileExistsAtPath: databasePath] ){
        
        NSString *dbFileBundlePath =  [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSData *tmpData = [NSData dataWithContentsOfFile:dbFileBundlePath];
        if( [tmpData writeToFile:databasePath atomically:YES] == YES){
            return databasePath;
        }
    }
    return nil;
}


-(BOOL)initWithBundleDBPath:(NSString *)path{
    
    const char *dbpath = [path UTF8String];
    if (sqlite3_open(dbpath, &myDB) == SQLITE_OK){
        return YES;
    }else{
        return NO;
    }
}


-(BOOL)execSql:(NSString *)sql{
    
    const char *sql_stmt = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    char *errMsg;
    if (sqlite3_exec(myDB, sql_stmt, NULL, NULL, &errMsg) ==SQLITE_OK) {
        NSLog(@"execSql error:%s",errMsg);
        return YES;
    }else{
        return NO;
    }
}


-(NSArray *)getQueryResult:(NSString *)sql{
    
    NSMutableArray *resultArr = [NSMutableArray array];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];

    char *errMsg;
    const char *sql_stmt = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    if (sqlite3_exec(myDB, sql_stmt, NULL, NULL, &errMsg) ==SQLITE_OK) {
        
            int result;
            char * errmsg = NULL;
            char **dbResult; 
            int nRow, nColumn;
            int i , j;
            int index;
            
            // dbResult is char **, and now it`s char ***
            result = sqlite3_get_table( myDB , sql_stmt, &dbResult, &nRow, &nColumn, &errmsg );
            if( SQLITE_OK == result )
            {
                index = nColumn;
                
                for(  i = 0; i < nRow ; i++ )
                {
                    for( j = 0 ; j < nColumn; j++ )
                    {
                        NSString *tmpKey =    [NSString stringWithUTF8String:dbResult[j] ];  
                        NSString *tmpValue = [NSString stringWithUTF8String:dbResult [index]];
                        [ resultDic setValue:tmpValue forKey:tmpKey ];
                        
                        ++index; 
                    }
                    [resultArr addObject:resultDic];
                    resultDic = [NSMutableDictionary dictionary];//create a new dictionary object for next row 
                }
            }
            //if success or not , release char**  memory
            sqlite3_free_table( dbResult );
    }else{
        NSLog(@"Query error!");
    }
    
    return resultArr;
}

//close DB
-(void)closeDB{
    sqlite3_close( myDB );
}
@end

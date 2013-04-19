//
//  DBManager.h
//  Area
//
//  Created by huliang on 13-4-18.
//  Copyright (c) 2013 huliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject{
    
    sqlite3 *myDB;
}

@property(nonatomic,retain)NSString *databasePath;
@property(nonatomic,retain)NSArray *sqlHistory;

//Tools Functions
+(NSString *)copyFromBundleToDocument:(NSString *)fileName;

-(BOOL)initWithBundleDBPath:(NSString *)path;       // init with db file path
-(BOOL)execSql:(NSString *)sql;                                 // excute like update delete etc.
-(NSArray *)getQueryResult:(NSString *)sql;            //excute quer liek select * xxx
-(void)closeDB;

@end

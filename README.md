Object-C_DBManager
==================

Object-C_DBManager, a tool for sqlite database writen by Object-C



@@Usage:

//    NSString *dbPath = [DBManager copyFromBundleToDocument:@"area.rdb"];// if need copy to Document to make it writeable
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"rdb"];
    
    DBManager *dbManager =[[DBManager alloc] init];
    [dbManager initWithBundleDBPath:dbPath];
    NSLog(@"%@",[dbManager getQueryResult:@"select * from area where areaid=1" ]);
    
    
    
@@ We get the Result:
    
    Area[20548:c07] (
        {
        name = "\U5317\U4eac\U5e02";
        pid = 1;
    },
        {
        name = "\U5929\U6d25\U5e02";
        pid = 2;
    }{
        name = "\U53f0\U6e7e\U7701";
        pid = 34;
    }

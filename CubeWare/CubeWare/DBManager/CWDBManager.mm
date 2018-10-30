//
//  CWDBManager.m
//  CubeWare
//
//  Created by 曾長歡 on 2017/12/26.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWDBManager.h"
#import <WCDB/WCTDatabase.h>

#import "CubeMessageEntity+WCDB.h"
#import "CWSession+WCDB.h"
#import "CubeWareHeader.h"
#import "CWDBUtil.h"

@interface CWDBManager()

@property (nonatomic, strong) NSMutableArray *tableClasses;

@end

@implementation CWDBManager{
	BOOL _useDefaultDabaBase;
}

-(instancetype)init{
	if(self = [super init])
	{
		_useDefaultDabaBase = YES;
		_tableClasses = [NSMutableArray arrayWithObjects:[CubeMessageEntity class],[CWSession class], nil];
	}
	return self;
}

+(instancetype)shareManager{
    static CWDBManager *dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[CWDBManager alloc] init];
        [[CWWorkerFinder defaultFinder] registerWorker:dbManager forProtocols:@[@protocol(CWMessageDBProtocol),@protocol(CWSessionDBProtocol),@protocol(CWInfoRefreshDelegate)]];
		
//        SQL Execution Monitor
//        [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
//            NSLog(@"SQL: %@", sql);
//        }];
    });
    return dbManager;
}

#pragma mark - getter and setter

-(void)setDelegate:(id<CWDBManagerDelegate>)delegate{
	_delegate = delegate;
	if(delegate && [delegate respondsToSelector:@selector(customDataBase)])
	{
		_useDefaultDabaBase = NO;
		_database = nil;
	}
	else
	{
		_useDefaultDabaBase = YES;
	}
}

-(WCTDatabase *)database{
	if(_useDefaultDabaBase)
	{
		if(!_database)
		{
			_database = [CWDBManager databaseForUser:[CWUserModel currentUser]];
		}
		return _database;
	}
	else
	{
		return [self.delegate customDataBase];
	}
}

+(WCTDatabase *)databaseForUser:(CWUserModel *)user{
    WCTDatabase *db = nil;
    if(user.cubeId.length){
        NSString *dbFolder = [NSString stringWithFormat:@"%@/Documents/CubeWare/cubeDB/",NSHomeDirectory()];
        NSString *dbPath = [NSString stringWithFormat:@"%@CW_%@.sqlite",dbFolder,user.cubeId];
        db = [[WCTDatabase alloc] initWithPath:dbPath];
        [self creatTableForDatbaBase:db];
    }
    return db;
}

#pragma mark - manage table

-(void)addTableOfClass:(NSArray<Class<CWDiskCacheProtocol>> *)classes{
	if(classes.count)
	{
		[self.tableClasses removeObjectsInArray:classes];
		[self.tableClasses addObjectsFromArray:classes];
	}
}

-(void)creatTableForCurrentDatabase{
	[CWDBManager creatTableForDatbaBase:self.database];
}

+(void)creatTableForDatbaBase:(WCTDatabase *)db
{
	if(db)
	{
		for (Class cls in [CWDBManager shareManager].tableClasses) {
			[db createTableAndIndexesOfName:[cls tableName] withClass:(Class<WCTTableCoding>)cls];
		}
	}
}

#pragma mark - CWUserInfoRefreshProtocol
-(void)changeCurrentUser:(CWUserModel *)user{
	if(_useDefaultDabaBase)
	{
		NSString *currentDBUserId = [[_database.path componentsSeparatedByString:@"_"] lastObject];
		currentDBUserId = [currentDBUserId stringByDeletingPathExtension];
		if(![currentDBUserId isEqualToString:user.cubeId])
		{
			_database = [CWDBManager databaseForUser:user];
		}
	}
}

#pragma mark - CURD

-(BOOL)saveOrUpdate:(NSObject *)obj{
    BOOL success = NO;
    if([obj conformsToProtocol: @protocol(WCTTableCoding)])
    {
        success = [self.database insertOrReplaceObject:(id<WCTTableCoding,NSObject>)obj into:[[obj class] tableName]];
    }
    else
    {
        NSLog(@"------ db ------:save objc:%@ error: class %@ don't confirm protocol WCTTableCoding",obj,NSStringFromClass([obj class]));
    }
    return success;
}

-(BOOL)saveOrUpdateObjs:(NSArray *)objs{
    BOOL success = NO;
    id obj = [objs firstObject];
    
    if([obj conformsToProtocol: @protocol(WCTTableCoding)])
    {
        success = [self.database insertOrReplaceObjects:objs into:[[obj class] tableName]];
    }
    else
    {
        NSLog(@"------ db ------:save objc:%@ error: class %@ don't confirm protocol WCTTableCoding",obj,NSStringFromClass([obj class]));
    }
    return success;
}

#pragma mark -- CWMessageDBProtocol
-(BOOL)saveOrUpdateMessage:(CubeMessageEntity *)msg{
    return [self saveOrUpdate:msg];
}

-(BOOL)saveOrUpdateMessages:(NSArray<CubeMessageEntity *> *)msgs{
    return [self saveOrUpdateObjs:msgs];
}

-(CubeMessageEntity *)messageWithMessageSN:(long long)SN
{
    NSString *jsonString =  (id)[[self.database getOneColumnOnResult:CubeMessageEntity.json fromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.SN==SN] firstObject];
    return jsonString ? [CubeMessageEntity objectWithJson:jsonString] : nil;
}

-(NSMutableArray<CubeMessageEntity *> *)messagesWithTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId{
    WCTCondition condition = [CWDBUtil conditionWithTimestamp:timestamp andTimeRelation:relation forProperty:CubeMessageEntity.timestamp];
    WCTOrderByList order = [CWDBUtil conditionWithSortType:sort forProperty:CubeMessageEntity.timestamp];
    NSMutableArray *messagesArray = [NSMutableArray array];
    NSArray *jsonArray = [self.database getOneColumnOnResult:CubeMessageEntity.json fromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.sessionId==sessionId && condition && CubeMessageEntity.needShow == YES orderBy:order limit:limit];
    for (NSString *jsonStirng in jsonArray) {
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonStirng dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        CubeMessageEntity *message = [CubeMessageEntity fromDictionary:jsonDic];
        message.json = jsonStirng;
        [messagesArray addObject:message];
    }
    return messagesArray;
}

-(void)messagesWithTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId withCompleteHandler:(void (^)(NSMutableArray<CubeMessageEntity *> *))handler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        handler([self messagesWithTimestamp:timestamp relatedBy:relation andLimit:limit andSortBy:sort forSession:sessionId]);
    });
}

-(NSMutableArray<CubeMessageEntity *> *)messagesWithType:(CubeMessageType)type andTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId{
	WCTCondition condition = [CWDBUtil conditionWithTimestamp:timestamp andTimeRelation:relation forProperty:CubeMessageEntity.timestamp];
	WCTOrderByList order = [CWDBUtil conditionWithSortType:sort forProperty:CubeMessageEntity.timestamp];
	NSMutableArray *messagesArray = [NSMutableArray array];
    NSArray *jsonArray = [self.database getOneColumnOnResult:CubeMessageEntity.json fromTable:[CubeMessageEntity tableName] where:(sessionId.length > 0 ? CubeMessageEntity.sessionId==sessionId : 1) && condition && CubeMessageEntity.needShow == YES && CubeMessageEntity.type == type orderBy:order limit:limit];
	for (NSString *jsonStirng in jsonArray) {
		NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonStirng dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
		CubeMessageEntity *message = [CubeMessageEntity fromDictionary:jsonDic];
		message.json = jsonStirng;
		[messagesArray addObject:message];
	}
	return messagesArray;
}

-(void)messagesWithType:(CubeMessageType)type andTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort forSession:(NSString *)sessionId withCompleteHandler:(void (^)(NSMutableArray<CubeMessageEntity *> *))handler{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		handler([self messagesWithType:type andTimestamp:timestamp relatedBy:relation andLimit:limit andSortBy:sort forSession:sessionId]);
	});
}

-(CubeMessageEntity *)latestReceivedMessageForSession:(NSString *)sessionId{
    NSString *json = (id)[[self.database getOneColumnOnResult:CubeMessageEntity.json fromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.sessionId == sessionId && CubeMessageEntity.needShow == YES && CubeMessageEntity.messageDirection == CubeMessageDirectionReceived orderBy:CubeMessageEntity.timestamp.order(WCTOrderedDescending) limit:1] firstObject];
    return json.length ? [CubeMessageEntity objectWithJson:json] : nil;
}

-(CubeMessageEntity *)oldestUnreadMessageForSession:(NSString *)sessionId{
     NSString *json = (id)[[self.database getOneColumnOnResult:CubeMessageEntity.json fromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.sessionId == sessionId && CubeMessageEntity.needShow == YES && CubeMessageEntity.messageDirection == CubeMessageDirectionReceived && CubeMessageEntity.receipted == NO orderBy:CubeMessageEntity.timestamp.order(WCTOrderedAscending) limit:1] firstObject];
    return json.length ? [CubeMessageEntity objectWithJson:json] : nil;
}

-(NSInteger)countMessagesAfter:(CubeMessageEntity *)message inSession:(NSString *)sessionId{
	return [[self.database getOneValueOnResult:CubeMessageEntity.SN.count() fromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.sessionId == sessionId && CubeMessageEntity.needShow == YES && CubeMessageEntity.timestamp >= message.timestamp] integerValue];
}

-(BOOL)deleteMessageWithMessageSN:(long long)SN
{
    return  [self.database deleteObjectsFromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.SN==SN];
}

#pragma mark - CWSessionDBProtocol
-(BOOL)saveOrUpdateSession:(CWSession *)session{
    return [self saveOrUpdate:session];
}

-(BOOL)saveOrUpdateSessions:(NSArray *)sessions{
    return [self saveOrUpdateObjs:sessions];
}

-(BOOL)deleteSessions:(NSArray<CWSession *> *)sessions{
	NSMutableArray *sessionIds = [NSMutableArray array];
	for (CWSession *session in sessions) {
		[sessionIds addObject:session.sessionId];
	}
	return [self.database deleteObjectsFromTable:[CWSession tableName] where:CWSession.sessionId.in(sessionIds)];
}

-(CWSession *)sessionWithSessionId:(NSString *)sessionId{
    CWSession *session = [self.database getOneObjectOfClass:[CWSession class] fromTable:[CWSession tableName] where:CWSession.sessionId == sessionId];
    return session;
}

-(void)sessionWithTimestamp:(long long)timestamp relatedBy:(CWTimeRelation)relation andLimit:(int)limit andSortBy:(CWSortType)sort withCompleteHandler:(void (^)(NSMutableArray<CWSession *> *))handler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        WCTCondition condition = [CWDBUtil conditionWithTimestamp:timestamp andTimeRelation:relation forProperty:CWSession.lastesTimestamp];
        WCTOrderBy timeOrder = [CWDBUtil conditionWithSortType:sort forProperty:CWSession.lastesTimestamp];
		WCTOrderBy topedOrder = [CWDBUtil conditionWithSortType:CWSortTypeDESC forProperty:CWSession.topped];
		NSMutableArray *sessions = [[self.database getObjectsOfClass:[CWSession class] fromTable:[CWSession tableName] where:condition orderBy:{topedOrder,timeOrder}] mutableCopy];
		
        handler(sessions);
    });
}

-(NSInteger)unreadCountForSession:(CWSession *)session{
     return [[self.database getOneValueOnResult:CubeMessageEntity.SN.count() fromTable:[CubeMessageEntity tableName] where:CubeMessageEntity.sessionId == session.sessionId && CubeMessageEntity.receipted == NO && CubeMessageEntity.messageDirection == CubeMessageDirectionReceived] integerValue];
}

-(void)readedMessagesbefore:(long long)time inSession:(CWSession *)session{
    [self.database updateRowsInTable:[CubeMessageEntity tableName] onProperty:CubeMessageEntity.receipted withValue:@(1) where:CubeMessageEntity.sessionId == session.sessionId and CubeMessageEntity.receipted == NO and  CubeMessageEntity.messageDirection == CubeMessageDirectionReceived and CubeMessageEntity.timestamp <= time];
}

@end

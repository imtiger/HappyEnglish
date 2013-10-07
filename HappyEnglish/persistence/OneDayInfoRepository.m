//
// Created by @krq_tiger on 13-6-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

//create table onedayinfo(id INTEGER PRIMARY KEY,chineseText text,englishText text,detailAudioUrl text,normalAudioUrl text,slowAudioUrl text,createDate text,issueNumber INTEGER);
//CREATE TABLE onedayinfo(chineseText text,englishText text,detailAudioUrl text,normalAudioUrl text,slowAudioUrl text,createDate text,issueNumber INTEGER,isFavorite INTEGER default 0);
//sqlite3 xxx.sqlite  .tables drop table xxx  .schema tablename
#import "OneDayInfoRepository.h"
#import "OneDayInfo.h"
#import "Global.h"

static NSString *sqlite_db_name = @"happyenglish.sqlite";
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *update_statement = nil;
static sqlite3_stmt *get_statement_byId = nil;
static sqlite3_stmt *get_episodes_with_date = nil;
static sqlite3_stmt *get_episodes_with_issueNumber = nil;
static sqlite3_stmt *get_episodes_paging = nil;
static sqlite3_stmt *get_favorite_episodes_paging = nil;
static sqlite3_stmt *get_all_favorite_episodes = nil;
static sqlite3_stmt *get_episodes_with_numbers = nil;
static sqlite3_stmt *is_favorite = nil;


@implementation OneDayInfoRepository {
    sqlite3 *_database;
}

+ (OneDayInfoRepository *)sharedInstance {
    static OneDayInfoRepository *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OneDayInfoRepository alloc] init];
        [self createEditableCopyOfDatabaseIfNeeded];
        [sharedInstance initializeDatabase];
    });
    return sharedInstance;
}


- (NSInteger)createOneDayInfo:(OneDayInfo *)oneDayInfo {
    if (insert_statement == nil) {
        static char *sql = "INSERT OR REPLACE INTO onedayinfo (rowid,chineseText,englishText,detailAudioUrl,normalAudioUrl,slowAudioUrl,createDate,issueNumber,isFavorite) VALUES(?,?,?,?,?,?,?,?,COALESCE((select isFavorite from onedayinfo where rowid=?),0))";
        if (sqlite3_prepare_v2(_database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            //TODO
            //NSLog(@"%s", sqlite3_errmsg(_database));
        }
    }
    sqlite3_bind_int(insert_statement, 1, oneDayInfo.id);
    sqlite3_bind_text(insert_statement, 2, [oneDayInfo.chineseText UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 3, [oneDayInfo.englishText UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 4, [oneDayInfo.detailAudioUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 5, [oneDayInfo.normalAudioUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 6, [oneDayInfo.slowAudioUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 7, [[Global formatDate:oneDayInfo.createDate] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_statement, 8, oneDayInfo.issueNumber);
    sqlite3_bind_int(insert_statement, 9, oneDayInfo.id);
    int success = sqlite3_step(insert_statement);
    sqlite3_reset(insert_statement);
    if (success != SQLITE_ERROR) {
        return sqlite3_last_insert_rowid(_database);
    }
    return -1;
}

- (OneDayInfo *)getOneDayInfoById:(NSInteger)id {
    if (get_statement_byId == nil) {
        static char *sql = "select rowid,* from onedayinfo where rowid = ?";
        if (sqlite3_prepare_v2(_database, sql, -1, &get_statement_byId, NULL) != SQLITE_OK) {
            //TODO
            //NSLog(@"%s", sqlite3_errmsg(_database));

        }
    }
    OneDayInfo *oneDayInfo = [[OneDayInfo alloc] init];
    sqlite3_bind_int(get_statement_byId, 1, id);
    if (sqlite3_step(get_statement_byId) == SQLITE_ROW) {
        oneDayInfo = [self getInfoFromStatement:get_statement_byId];
    }
    sqlite3_reset(get_statement_byId);
    return oneDayInfo;
}

- (NSMutableArray *)getEpisodesWithBeginDate:(NSDate *)beginDate andEndDate:(NSDate *)endDate {
    static char *sql = "select rowid,* from onedayinfo where createDate >= ? AND createDate <= ?";
    if (sqlite3_prepare_v2(_database, sql, -1, &get_episodes_with_date, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *begin = [formatter stringFromDate:beginDate];
    NSString *end = [formatter stringFromDate:endDate];
    //NSLog(@"begin=%@,end=%@", begin, end);
    sqlite3_bind_text(get_episodes_with_date, 1, [begin UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(get_episodes_with_date, 2, [end UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableArray *episodes = [[NSMutableArray alloc] init];
    while (sqlite3_step(get_episodes_with_date) == SQLITE_ROW) {
        [episodes addObject:[self getInfoFromStatement:get_episodes_with_date]];
    }
    sqlite3_finalize(get_episodes_with_date);
    return episodes;
}

- (NSMutableArray *)getEpisodesWithStartAndEndNumber:(int)startNumber endNumber:(int)endNumber {
    static char *sql = "select rowid,* from onedayinfo where issueNumber >= ? AND issueNumber <= ?";
    if (sqlite3_prepare_v2(_database, sql, -1, &get_episodes_with_issueNumber, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    sqlite3_bind_int(get_episodes_with_issueNumber, 1, startNumber);
    sqlite3_bind_int(get_episodes_with_issueNumber, 2, endNumber);
    NSMutableArray *episodes = [[NSMutableArray alloc] init];
    while (sqlite3_step(get_episodes_with_issueNumber) == SQLITE_ROW) {
        [episodes addObject:[self getInfoFromStatement:get_episodes_with_issueNumber]];
    }
    sqlite3_finalize(get_episodes_with_issueNumber);
    return episodes;
}


- (NSMutableArray *)getEpisodesWithBeginIndex:(int)beginIndex andPageSize:(int)pageSize {
    char *sql = "select rowid,* from onedayinfo order by createDate desc LIMIT ? OFFSET ?";
    if (sqlite3_prepare_v2(_database, sql, -1, &get_episodes_paging, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    sqlite3_bind_int(get_episodes_paging, 1, pageSize);
    sqlite3_bind_int(get_episodes_paging, 2, beginIndex);
    NSMutableArray *episodes = [[NSMutableArray alloc] init];
    while (sqlite3_step(get_episodes_paging) == SQLITE_ROW) {
        [episodes addObject:[self getInfoFromStatement:get_episodes_paging]];
    }
    sqlite3_finalize(get_episodes_paging);
    return episodes;
}


- (NSMutableArray *)getFavoriteEpisodesWithBeginIndex:(int)beginIndex andPageSize:(int)pageSize {
    char *sql = "select rowid,* from onedayinfo where isFavorite=1 order by createDate desc LIMIT ? OFFSET ?";
    if (sqlite3_prepare_v2(_database, sql, -1, &get_favorite_episodes_paging, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    sqlite3_bind_int(get_favorite_episodes_paging, 1, pageSize);
    sqlite3_bind_int(get_favorite_episodes_paging, 2, beginIndex);
    NSMutableArray *episodes = [[NSMutableArray alloc] init];
    while (sqlite3_step(get_favorite_episodes_paging) == SQLITE_ROW) {
        [episodes addObject:[self getInfoFromStatement:get_favorite_episodes_paging]];
    }
    sqlite3_finalize(get_favorite_episodes_paging);
    return episodes;
}

- (NSMutableArray *)getAllFavoriteEpisodes {
    char *sql = "select rowid,* from onedayinfo where isFavorite=1 order by createDate desc";
    if (sqlite3_prepare_v2(_database, sql, -1, &get_all_favorite_episodes, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    NSMutableArray *episodes = [[NSMutableArray alloc] init];
    while (sqlite3_step(get_all_favorite_episodes) == SQLITE_ROW) {
        [episodes addObject:[self getInfoFromStatement:get_all_favorite_episodes]];
    }
    sqlite3_finalize(get_all_favorite_episodes);
    return episodes;
}


- (void)updateOneDayInfo:(OneDayInfo *)oneDayInfo {
    if (update_statement == nil) {
        char *sql = "update onedayinfo set chineseText=?,englishText=?,detailAudioUrl=?,normalAudioUrl=?,slowAudioUrl=?,createDate=?,issueNumber=?,isFavorite=? where rowid=?";
        if (sqlite3_prepare_v2(_database, sql, -1, &update_statement, NULL) != SQLITE_OK) {
            //TODO
            //NSLog(@"%s", sqlite3_errmsg(_database));
        }
    }
    sqlite3_bind_text(update_statement, 1, [oneDayInfo.chineseText UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 2, [oneDayInfo.englishText UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 3, [oneDayInfo.detailAudioUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 4, [oneDayInfo.normalAudioUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 5, [oneDayInfo.slowAudioUrl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 6, [[Global formatDate:oneDayInfo.createDate] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(update_statement, 7, oneDayInfo.issueNumber);
    sqlite3_bind_int(update_statement, 8, oneDayInfo.isFavorite);
    sqlite3_bind_int(update_statement, 9, oneDayInfo.id);
    sqlite3_step(update_statement);
    sqlite3_reset(update_statement);
}

- (BOOL)isFavorite:(OneDayInfo *)oneDayInfo {
    char *sql = "select isFavorite from onedayinfo where rowid=?";
    if (sqlite3_prepare_v2(_database, sql, -1, &is_favorite, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    sqlite3_bind_int(is_favorite, 1, oneDayInfo.id);
    sqlite3_step(is_favorite);
    BOOL isFavorite = sqlite3_column_int(is_favorite, 0);
    sqlite3_finalize(is_favorite);
    return isFavorite;
}


- (NSMutableArray *)getEpisodesBetween:(int)startNumber andEndNumber:(int)endNumber {
    char *sql = "select rowid,* from onedayinfo where issueNumber >= ? AND issueNumber <= ?";
    if (sqlite3_prepare_v2(_database, sql, -1, &get_episodes_with_numbers, NULL) != SQLITE_OK) {
        //TODO
        //NSLog(@"%s", sqlite3_errmsg(_database));
    }
    sqlite3_bind_int(get_episodes_with_numbers, 1, startNumber);
    sqlite3_bind_int(get_episodes_with_numbers, 2, endNumber);
    NSMutableArray *episodes = [[NSMutableArray alloc] init];
    while (sqlite3_step(get_episodes_with_numbers) == SQLITE_ROW) {
        [episodes addObject:[self getInfoFromStatement:get_episodes_with_numbers]];
    }
    sqlite3_finalize(get_episodes_with_numbers);
    return episodes;
}


#pragma mark - private method -
// Creates a writable copy of the bundled default database in the application Documents directory.
+ (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:sqlite_db_name];
    if ([fileManager fileExistsAtPath:writableDBPath]) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqlite_db_name];
    if (!([fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error])) {
        //NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        //TODO
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeDatabase {
    // The database is stored in the application bundle.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:sqlite_db_name];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &_database) == SQLITE_OK) {
    } else {
        //NSLog(@"初始化数据库失败");
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(_database);
        //TODO
    }
}

- (OneDayInfo *)getInfoFromStatement:(sqlite3_stmt *)statement {
    OneDayInfo *oneDayInfo = [[OneDayInfo alloc] init];
    // The second parameter indicates the column index into the result set.
    oneDayInfo.id = sqlite3_column_int(statement, 0);
    unsigned char const *bytes = sqlite3_column_text(statement, 1);
    oneDayInfo.chineseText = [[NSString alloc] initWithUTF8String:bytes];
    bytes = sqlite3_column_text(statement, 2);
    oneDayInfo.englishText = [[NSString alloc] initWithUTF8String:bytes];
    bytes = sqlite3_column_text(statement, 3);
    oneDayInfo.detailAudioUrl = [[NSString alloc] initWithUTF8String:bytes];
    bytes = sqlite3_column_text(statement, 4);
    oneDayInfo.normalAudioUrl = [[NSString alloc] initWithUTF8String:bytes];
    bytes = sqlite3_column_text(statement, 5);
    oneDayInfo.slowAudioUrl = [[NSString alloc] initWithUTF8String:bytes];
    bytes = sqlite3_column_text(statement, 6);
    oneDayInfo.createDate = [Global convertToDate:[[NSString alloc] initWithUTF8String:bytes]];
    oneDayInfo.issueNumber = sqlite3_column_int(statement, 7);
    oneDayInfo.isFavorite = sqlite3_column_int(statement, 8);
    return oneDayInfo;
}

@end
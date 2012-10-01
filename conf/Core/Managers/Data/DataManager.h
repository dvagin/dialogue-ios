//
//  DataManager.h


#import <Foundation/Foundation.h>
#import "BaseDataSource.h"

#define DATA_MANAGER [DataManager defaultManager]

typedef int rssDataType;

enum rssDataType {
    rssDataTypeNews = 0,
    rssDataTypePolitics = 1,
    rssDataTypeEconomics = 2,
    rssDataTypeSociety = 3,
    rssDataTypeEvents = 4
    };

@interface DataManager : NSObject
{
    NSMutableDictionary* _dataSources;
    NSLock* _lock;
}

+ (DataManager*) defaultManager;

- (void) dispose;

//- (void) setDataSource:(BaseDataSource*)dataSource forKey:(NSString*)key;
//- (void) removeDataSourceWithKey:(NSString*)key;
   
- (BaseDataSource*) getDataSourceOfType:(Class)dataSourceClass;
- (BaseDataSource*) getDataSourceOfType:(Class)type rssType:(rssDataType)rssType;

- (void) updateDataSourceWithType:(Class)type;
- (void) updateAllDataSources;

@end

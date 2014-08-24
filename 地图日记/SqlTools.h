//
//  SqlTools.h
//  Datastore Examples
//
//  Created by chenguandong on 14-5-22.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface SqlTools : NSObject

+(void)getFMdatabase;
+(NSString*)getdbPath;
+(NSMutableArray*)queryData:(NSString*)sql;
@end

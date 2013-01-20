//
//  UserQuery.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboQuery.h"

@class WeiboQuery, WeiboRequest, User;

@interface UserQuery : WeiboQuery

@property (copy) void (^completionBlock)(WeiboRequest *request, User *user, NSError *error);

+ (UserQuery *)query;

- (void)queryWithUserId:(long long)userId;
- (void)queryWithScreenName:(NSString *)screenName;

@end

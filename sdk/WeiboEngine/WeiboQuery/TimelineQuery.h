//
//  StatusesQuery.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-5.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboQuery.h"

@class WeiboRequest;

typedef enum {
  StatusTimelineFriends = 0,
  StatusTimelineMentions = 1,
} StatusTimeline;

@interface TimelineQuery : WeiboQuery

@property (copy) void (^completionBlock)(WeiboRequest *request, NSMutableArray *statuses, NSError *error);

+ (TimelineQuery *)query;

- (void)queryTimeline:(StatusTimeline)timeline sinceId:(long long)sinceId
                maxId:(long long)maxId count:(int)count;
- (void)queryTimeline:(StatusTimeline)timeline sinceId:(long long)sinceId
                count:(int)count;
- (void)queryTimeline:(StatusTimeline)timeline maxId:(long long)maxId
                count:(int)count;
- (void)queryTimeline:(StatusTimeline)timeline count:(int)cout;


@end

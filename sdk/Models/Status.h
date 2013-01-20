//
//  Status.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-9-4.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GeoInfo, User;

@interface Status : NSObject<NSCoding> 

+ (Status *)statusWithJsonDictionary:(NSDictionary*)dic;
- (id)initWithJsonDictionary:(NSDictionary*)dic;

@property (nonatomic, strong) NSString *statusIdString;
@property (nonatomic, assign) time_t createdAt;
@property (nonatomic, assign) long long statusId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *sourceUrl;
@property (nonatomic, assign, getter=isFavorited) BOOL favorited;
@property (nonatomic, assign, getter=isTruncated) BOOL truncated;
@property (nonatomic, assign) long long inReplyToStatusId;
@property (nonatomic, assign) long long inReplyToUserId;
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, assign) long long mid;
@property (nonatomic, strong) NSString *middleImageUrl;
@property (nonatomic, strong) NSString *originalImageUrl;
@property (nonatomic, strong) NSString *thumbnailImageUrl;
@property (nonatomic, assign) int repostsCount;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, strong) GeoInfo *geo;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Status *retweetedStatus;
@property (nonatomic, readonly) NSNumber *statusKey;

- (NSString*)statusTimeString;
- (NSString*)statusDateTimeString;

@end

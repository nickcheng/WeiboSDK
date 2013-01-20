//
//  WeiboQuery.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-31.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboRequest;

@interface WeiboQuery : NSObject {
  WeiboRequest *_request;
}

- (void)cancel;
- (void)getWithAPIPath:(NSString *)apiPath params:(NSMutableDictionary *)params;
- (void)postWithAPIPath:(NSString *)apiPath params:(NSMutableDictionary *)params;

@end

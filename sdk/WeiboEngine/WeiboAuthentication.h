//
//  WeiboAuthorize.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboAuthentication : NSObject

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, strong) NSString *redirectURI;

@property (nonatomic, strong) NSString *authorizeURL;
@property (nonatomic, strong) NSString *accessTokenURL;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSDate *expirationDate;

- (id)initWithAuthorizeURL:(NSString *)authorizeURL accessTokenURL:(NSString *)accessTokenURL
                    appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (NSString *)authorizeRequestUrl;

@end

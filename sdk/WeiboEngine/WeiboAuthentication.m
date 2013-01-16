//
//  WeiboAuthorize.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAuthentication.h"

@implementation WeiboAuthentication {
  NSString *_appKey;
  NSString *_appSecret;
  NSString *_redirectURI;
  
  NSString *_authorizeURL;
  NSString *_accessTokenURL;
  
  NSString *_accessToken;
  NSString *_userId;
  NSDate *_expirationDate;
}

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectURI = _redirectURI;

@synthesize authorizeURL = _authorizeURL;
@synthesize accessTokenURL = _accessTokenURL;

@synthesize accessToken = _accessToken;
@synthesize userId = _userId;
@synthesize expirationDate = _expirationDate;

- (id)initWithAuthorizeURL:(NSString *)authorizeURL accessTokenURL:(NSString *)accessTokenURL
                    appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
  self = [super init];
  if (self) {
    _authorizeURL = authorizeURL;
    _accessTokenURL = accessTokenURL;
    _appKey = appKey;
    _appSecret = appSecret;
    _redirectURI = @"http://";
  }
  return self;
}

- (NSString *)authorizeRequestUrl {
  return [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@&display=mobile", self.authorizeURL,
          [self.appKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
          [self.redirectURI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end

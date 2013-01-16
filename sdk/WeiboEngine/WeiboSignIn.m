//
//  WeiboSignIn.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-29.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboSignIn.h"
#import "WeiboSignInViewController.h"
#import "WeiboConfig.h"
#import "WeiboAuthentication.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

static NSString *WeiboOAuth2ErrorDomain = @"com.zhiweibo.OAuth2";

@implementation WeiboSignIn {
  
  WeiboAuthentication *_authentication;
}

@synthesize authentication = _authentication;
@synthesize delegate;

- (id)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret {
  self = [super init];
  if (self) {
    _authentication = [[WeiboAuthentication alloc]initWithAuthorizeURL:kWeiboAuthorizeURL
                                                        accessTokenURL:kWeiboAccessTokenURL
                                                                appKey:appKey
                                                             appSecret:appSecret];
    
  }
  return self;
}

- (void)signInOnViewController:(UIViewController *)viewController {
  WeiboSignInViewController *signInWeiboController = [[WeiboSignInViewController alloc]initWithNibName:nil bundle:nil];
  signInWeiboController.delegate = self;
  signInWeiboController.authentication = self.authentication;
  UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:signInWeiboController];
  [viewController presentViewController:navController animated:YES completion:NULL];
}

- (void)didCancelled {
  if (self.delegate && [self.delegate respondsToSelector:@selector(authCancelled)]) {
    [self.delegate authCancelled];
  }
}

- (void)didReceiveAuthorizeCode:(NSString *)code {
  // if it was not canceled
  if (![code isEqualToString:@"21330"]) {
    [self accessTokenWithAuthorizeCode:code];
  }
  else {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Access denied", NSLocalizedDescriptionKey,
                              nil];
    NSError *error = [NSError errorWithDomain:WeiboOAuth2ErrorDomain
                                         code:kWeiboOAuth2ErrorAccessDenied
                                     userInfo:userInfo];
    if (self.delegate) {
      [self.delegate finishedWithAuth:self.authentication error:error];
    }
  }
}

- (void)accessTokenWithAuthorizeCode:(NSString *)code {
  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.authentication.accessTokenURL]];
  [request addPostValue:self.authentication.appKey forKey:@"client_id"];
  [request addPostValue:self.authentication.appSecret forKey:@"client_secret"];
  [request addPostValue:self.authentication.redirectURI forKey:@"redirect_uri"];
  [request addPostValue:code forKey:@"code"];
  [request addPostValue:@"authorization_code" forKey:@"grant_type"];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  JSONDecoder *decoder = [JSONDecoder decoder];
  id jsonObject = [decoder mutableObjectWithData:[request responseData]];
  if ([jsonObject isKindOfClass:[NSDictionary class]]) {
    NSDictionary *dict = (NSDictionary *)jsonObject;
    
    NSString *accessToken = [dict objectForKey:@"access_token"];
    NSString *userId = [dict objectForKey:@"uid"];
    int expiresIn = [[dict objectForKey:@"expires_in"] intValue];
    
    if (accessToken.length > 0 && userId.length > 0) {
      self.authentication.accessToken = accessToken;
      self.authentication.userId = userId;
      self.authentication.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
      
      if (self.delegate) {
        [self.delegate finishedWithAuth:self.authentication error:nil];
      }
      return;
    }
  }
  
  NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"Failed to parse response data: \r\n%@",[request responseString]],NSLocalizedDescriptionKey,
                            nil];
  NSError *error = [NSError errorWithDomain:WeiboOAuth2ErrorDomain
                                       code:kWeiboOAuth2ErrorTokenUnavailable
                                   userInfo:userInfo];
  if (self.delegate) {
    [self.delegate finishedWithAuth:self.authentication error:error];
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  NSDictionary *userInfo = [request error].userInfo;
  NSError *error = [NSError errorWithDomain:WeiboOAuth2ErrorDomain
                                       code:kWeiboOAuth2ErrorAccessTokenRequestFailed
                                   userInfo:userInfo];
  if (self.delegate) {
    [self.delegate finishedWithAuth:self.authentication error:error];
  }
}

@end

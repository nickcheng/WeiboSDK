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
#import "AFNetworking.h"

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
  } else {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Access denied", NSLocalizedDescriptionKey,
                              nil];
    NSError *error = [NSError errorWithDomain:kWeiboOAuth2ErrorDomain
                                         code:kWeiboOAuth2ErrorAccessDenied
                                     userInfo:userInfo];
    if (self.delegate) {
      [self.delegate finishedWithAuth:self.authentication error:error];
    }
  }
}

- (void)accessTokenWithAuthorizeCode:(NSString *)code {
  //
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kWeiboAPIBaseUrl]];
  NSDictionary *params = @{
    @"client_id" : self.authentication.appKey,
    @"client_secret": self.authentication.appSecret,
    @"redirect_uri": self.authentication.redirectURI,
    @"code": code,
    @"grant_type": @"authorization_code"
  };
  NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:self.authentication.accessTokenURL parameters:params];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
      NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to parse response data: \r\n%@", err]};
      NSError *error = [NSError errorWithDomain:kWeiboOAuth2ErrorDomain
                                           code:kWeiboOAuth2ErrorTokenUnavailable
                                       userInfo:userInfo];
      if (self.delegate)
        [self.delegate finishedWithAuth:self.authentication error:error];
    } else {
      NSString *accessToken = [dict objectForKey:@"access_token"];
      NSString *userId = [dict objectForKey:@"uid"];
      int expiresIn = [[dict objectForKey:@"expires_in"] intValue];
      
      if (accessToken.length > 0 && userId.length > 0) {
        self.authentication.accessToken = accessToken;
        self.authentication.userId = userId;
        self.authentication.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiresIn];
        
        if (self.delegate)
          [self.delegate finishedWithAuth:self.authentication error:nil];
        return;
      }
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    NSDictionary *userInfo = error.userInfo;
    NSError *err = [NSError errorWithDomain:kWeiboOAuth2ErrorDomain
                                       code:kWeiboOAuth2ErrorAccessTokenRequestFailed
                                   userInfo:userInfo];
    if (self.delegate) {
      [self.delegate finishedWithAuth:self.authentication error:err];
    }
  }];

  [operation start];
}

@end

//
//  WeiboRequest.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-30.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboRequest.h"
#import "WeiboAccounts.h"
#import "WeiboAccount.h"
#import "WeiboConfig.h"
#import "NSStringAdditions.h"
#import "AFNetworking.h"

static const int kGeneralErrorCode = 10000;

@interface WeiboRequest ()
@property (nonatomic,readwrite) BOOL sessionDidExpire;
@end

@implementation WeiboRequest {
//  ASIHTTPRequest *_request;
  AFHTTPRequestOperation *_operation;
  NSError *_error;
  BOOL _sessionDidExpire;
  NSString *_accessToken;
  NSInteger _tag;
}

@synthesize delegate;
@synthesize error = _error;
@synthesize accessToken = _accessToken;
@synthesize tag = _tag;

- (id)init {
  if (self = [super init]) {
    WeiboAccount *account = [[WeiboAccounts shared] currentAccount];
    if (account) {
      _accessToken = account.accessToken;
    }
  }
  return self;
}

- (id)initWithDelegate:(id<WeiboRequestDelegate>)dele {
  if (self = [self init]) {
    self.delegate = dele;
  }
  return self;
}

- (id)initWithAccessToken:(NSString *)accessToken delegate:(id<WeiboRequestDelegate>)dele {
  if (self = [super init]) {
    _accessToken = accessToken;
    self.delegate = dele;
  }
  return self;
}

+ (NSString*)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params {
  
  NSURL* parsedURL = [NSURL URLWithString:baseUrl];
  NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
  
  NSMutableArray* pairs = [NSMutableArray array];
  for (NSString* key in params.allKeys) {
    if (([params[key] isKindOfClass:[UIImage class]])
        ||([params[key] isKindOfClass:[NSData class]])) {
      continue;
    }
    
    NSString* escaped_value = [params[key] URLEncodedString];
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
  }
  NSString* query = [pairs componentsJoinedByString:@"&"];  
  return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

- (id)formError:(NSInteger)code userInfo:(NSDictionary *) errorData {
  return [NSError errorWithDomain:kWeiboAPIErrorDomain code:code userInfo:errorData];  
}

//- (id)parseJsonResponse:(NSData *)data error:(NSError **)error {
//	NSError *parseError = nil;
//  
//  JSONDecoder *parser = [JSONDecoder decoder];
//  id result = [parser mutableObjectWithData:data error:&parseError];
//  
//	if (parseError) {
//    if (error != nil) {
//      *error = [self formError:kGeneralErrorCode userInfo:parseError.userInfo];
//    }
//	}
//  
//	if ([result isKindOfClass:[NSDictionary class]]) {
//		if ([result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"] intValue] != 200) {
//			if (error != nil) {
//				*error = [self formError:[[result objectForKey:@"error_code"] intValue] userInfo:result];
//			}
//		}
//	}
//	
//	return result;
//}

- (void)failWithError:(NSError *)error {
  if (   [error code] == 21301
      || [error code] == 21314
      || [error code] == 21315
      || [error code] == 21316
      || [error code] == 21317
      || [error code] == 21332) {
    self.sessionDidExpire = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"authError" object:error];
  }
  if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
    [self.delegate request:self didFailWithError:error];
  }
}

- (void)loadSuccess:(id)result {
  if ([self.delegate respondsToSelector:@selector(request:didLoad:)]) {
    [self.delegate request:self didLoad:result];
  }
}

- (void)handleResponseData:(NSData *)data {
  NSError *error;
  NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
  self.error = error;
  
  if ([self.delegate respondsToSelector:@selector(request:didLoad:)] ||
      [self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
    if (error) {
      dispatch_async(dispatch_get_main_queue(),^(void) {
        [self failWithError:error];
      });
    }
    else {
      dispatch_async(dispatch_get_main_queue(),^(void) {
        [self loadSuccess:result];
      });
    }
  }
}

- (void)processParams:(NSMutableDictionary *)params {
  if (!params) {
    params = [NSMutableDictionary dictionary];
  }
  if (self.accessToken) {
    params[@"access_token"] = self.accessToken;
  }
}

- (void)getFromPath:(NSString *)apiPath params:(NSMutableDictionary *)params {
  NSString * fullURL = [kWeiboAPIBaseUrl stringByAppendingString:apiPath];
  return [self getFromUrl:fullURL params:params];
}

- (void)getFromUrl:(NSString *)url params:(NSMutableDictionary *)params {
  //
  [self processParams:params];
  
  //
  NSString* urlString = [[self class] serializeURL:url params:params];
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kWeiboAPIBaseUrl]];
  NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlString parameters:nil];
  [request addValue:kWeiboUserAgent forHTTPHeaderField:@"User-Agent"];
  
  if (_operation) {
    [_operation cancel];
    _operation = nil;
  }
  _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  __weak WeiboRequest *tempSelf = self;
  [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      [tempSelf handleResponseData:operation.responseData];
    });
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"_request error!!!, Reason:%@, errordetail:%@", error.localizedFailureReason, error.localizedDescription);
    [tempSelf failWithError:error];
  }];
  
  [_operation start];
}

- (NSString *)contentTypeForImageData:(NSData *)data {
  uint8_t c;
  [data getBytes:&c length:1];
  
  switch (c) {
    case 0xFF:
      return @"image/jpeg";
    case 0x89:
      return @"image/png";
    case 0x47:
      return @"image/gif";
    case 0x49:
    case 0x4D:
      return @"image/tiff";
  }
  return nil;
}

- (void)postToPath:(NSString *)apiPath params:(NSMutableDictionary *)params {
  NSString * fullURL = [kWeiboAPIBaseUrl stringByAppendingString:apiPath];
  return [self postToUrl:fullURL params:params];
}

- (void)postToUrl:(NSString *)url params:(NSMutableDictionary *)params {
  //
  [self processParams:params];
  
  //
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  NSString *dataKey = @"";
  for (NSString *key in params.allKeys) {
    id val = params[key];
    if ([val isKindOfClass:[NSData class]]) {
      if ([self contentTypeForImageData:val])
        dataKey = key;
      else
        [dict setObject:val forKey:key];
    } else if ([val isKindOfClass:[UIImage class]])
      dataKey = key;
    else
      [dict setObject:val forKey:key];
  }
  
  //
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kWeiboAPIBaseUrl]];
  NSMutableURLRequest *request;
  if (dataKey.length > 0) {
    request = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      NSData *data;
      if ([params[dataKey] isKindOfClass:[UIImage class]]) {
        data = UIImagePNGRepresentation((UIImage *)params[dataKey]);
        [formData appendPartWithFileData:data name:dataKey fileName:kWeiboUploadImageName mimeType:@"image/png"];
      } else {
        data = params[dataKey];
        NSString *contentType = [self contentTypeForImageData:params[dataKey]];
        NSString *fn = [contentType stringByReplacingOccurrencesOfString:@"/" withString:kWeiboUploadImageName];
        [formData appendPartWithFileData:data name:dataKey fileName:fn mimeType:contentType];
      }
    }];
  } else {
    request = [httpClient requestWithMethod:@"POST" path:url parameters:dict];
  }
  [request addValue:kWeiboUserAgent forHTTPHeaderField:@"User-Agent"];
  
  if (_operation) {
    [_operation cancel];
    _operation = nil;
  }
  _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  __weak WeiboRequest *tempSelf = self;
  [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      [tempSelf handleResponseData:operation.responseData];
    });
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"_request error!!!, Reason:%@, errordetail:%@", error.localizedFailureReason, error.localizedDescription);
    [tempSelf failWithError:error];
  }];
  
  [_operation start];
}

- (void)cancel {
  if (_operation) {
    [_operation cancel];
    _operation = nil;
  }
}

@end

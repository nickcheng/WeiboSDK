//
//  WeiboAccount.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAccount.h"

@implementation WeiboAccount {
  NSString *_userId;
  NSString *_accessToken;
  NSDate *_expirationDate;
  NSString *_screenName;
  NSString *_profileImageUrl;
  BOOL _selected;
}

@synthesize userId = _userId;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize screenName = _screenName;
@synthesize profileImageUrl = _profileImageUrl;
@synthesize selected = _selected;

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.expirationDate forKey:@"expirationDate"];
    [encoder encodeObject:self.screenName forKey:@"screenName"];
    [encoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
    [encoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super init];
  if (self) {
    _userId = [decoder decodeObjectForKey:@"userId"];
    _accessToken = [decoder decodeObjectForKey:@"accessToken"];
    _expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
    _screenName = [decoder decodeObjectForKey:@"screenName"];
    _profileImageUrl = [decoder decodeObjectForKey:@"profileImageUrl"];
    _selected = [decoder decodeBoolForKey:@"selected"];
  }
  return self;
}

@end

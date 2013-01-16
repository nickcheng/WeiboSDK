//
//  WeiboAccount.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-20.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboAccount : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, assign) BOOL selected;

@end

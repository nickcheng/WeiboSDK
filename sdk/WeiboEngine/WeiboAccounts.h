//
//  WeiboAccounts.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-21.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiboAccount, WeiboAuthentication;

@interface WeiboAccounts : NSObject

+ (WeiboAccounts *)shared;

@property (nonatomic, assign) WeiboAccount *currentAccount;
@property (nonatomic, readonly) NSMutableArray *accounts;

- (void)loadWeiboAccounts;
- (void)saveWeiboAccounts;
- (void)addAccount:(WeiboAccount *)account;
- (void)addAccountWithAuthentication:(WeiboAuthentication *)auth;
- (void)removeWeiboAccount:(WeiboAccount *)account;
- (void)syncAccount:(WeiboAccount *)account;
- (void)signOut;

@end

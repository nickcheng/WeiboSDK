//
//  WeiboAccounts.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-21.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboAccounts.h"
#import "WeiboAccount.h"
#import "WeiboAuthentication.h"
#import "UserQuery.h"
#import "PathHelper.h"
#import "User.h"

@implementation WeiboAccounts {
  NSMutableDictionary *_accountsDictionary;
  NSMutableArray *_accounts;
}

+ (WeiboAccounts *)shared {
  static WeiboAccounts *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[WeiboAccounts alloc] init];  // Do any other initialisation stuff in init.
  });
  return sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    _accountsDictionary = [[NSMutableDictionary alloc] init];
    _accounts = [[NSMutableArray alloc] init];
    [self loadWeiboAccounts];
  }
  return self;
}

- (NSString *)getWeiboAccountsStoragePath {
	NSString *filePath = [[PathHelper documentDirectoryPathWithName:@"db"]
                        stringByAppendingPathComponent:@"accounts.db"];
	return filePath;
}

- (void)loadWeiboAccounts {
	NSString *filePath = [self getWeiboAccountsStoragePath];
	NSArray *weiboAccounts = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	if (!weiboAccounts) {
		weiboAccounts = [[NSMutableArray alloc] init];
		[NSKeyedArchiver archiveRootObject:weiboAccounts toFile:filePath];
	}
	_accounts = [NSMutableArray arrayWithArray:weiboAccounts];
  for (WeiboAccount *account in _accounts) {
    _accountsDictionary[account.userId] = account;
  }
}

- (void)saveWeiboAccounts {
	NSString *filePath = [self getWeiboAccountsStoragePath];
	[NSKeyedArchiver archiveRootObject:_accounts toFile:filePath];
}

- (void)syncAccount:(WeiboAccount *)account {
  UserQuery *query = [UserQuery query];
  query.completionBlock = ^(WeiboRequest *request, User *user, NSError *error) {
    if (error) {
      //
      NSLog(@"UserQuery error: %@", error);
    } else {
      account.screenName = user.screenName;
      account.profileImageUrl = user.profileLargeImageUrl;
      [self saveWeiboAccounts];
    }
  };
  [query queryWithUserId:[account.userId longLongValue]];
}

- (void)addAccount:(WeiboAccount *)account {
  WeiboAccount *addedAccount = _accountsDictionary[account.userId];
  if (addedAccount) {
    addedAccount.accessToken = account.accessToken;
    addedAccount.expirationDate = account.expirationDate;
  } else {
    if (_accounts.count == 0) {
      account.selected = YES;
    }
    _accountsDictionary[account.userId] = account;
    [_accounts insertObject:account atIndex:0];
  }
  [self saveWeiboAccounts];
  if (!account.screenName || !account.profileImageUrl) {
    [self syncAccount:account];
  }
}

- (void)removeWeiboAccount:(WeiboAccount *)account {
  WeiboAccount *accountToBeRemoved = [_accountsDictionary objectForKey:account.userId];
  BOOL isCurrentAccount = accountToBeRemoved.selected;
  if (accountToBeRemoved) {
    [_accounts removeObject:accountToBeRemoved];
    [_accountsDictionary removeObjectForKey:account.userId];
  }
  if (isCurrentAccount) {
    if (_accounts.count > 0) {
      [_accounts[0] setSelected:YES];
    }
  }
  [self saveWeiboAccounts];
}

- (void)setCurrentAccount:(WeiboAccount *)currentAccount {
  for (WeiboAccount *account in _accounts) {
    account.selected = [account.userId isEqualToString:currentAccount.userId];
  }
  [self saveWeiboAccounts];
}

- (WeiboAccount *)currentAccount {
  for (WeiboAccount *account in _accounts) {
    if (account.selected) {
      return account;
    }
  }
  return nil;
}

- (void)signOut {
  WeiboAccount *currentAccount = [self currentAccount];
  if (currentAccount) {
    [self removeWeiboAccount:currentAccount];
  }
}

- (NSMutableArray *)accounts {
  return _accounts;
}

- (void)addAccountWithAuthentication:(WeiboAuthentication *)auth {
  WeiboAccount *account = [[WeiboAccount alloc]init];
  account.accessToken = auth.accessToken;
  account.userId = auth.userId;
  account.expirationDate = auth.expirationDate;
  
  [self addAccount:account];
}

@end

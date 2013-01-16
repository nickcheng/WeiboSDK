//
//  WeiboSignInViewController.h
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboAuthentication.h"
#import "MBProgressHUD.h"

@interface WeiboSignInViewController : UIViewController<UIWebViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) WeiboAuthentication *authentication;
@property (weak) id delegate;

@end

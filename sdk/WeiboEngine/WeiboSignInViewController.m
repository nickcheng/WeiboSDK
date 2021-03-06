//
//  WeiboSignInViewController.m
//  ZhiWeiboPhone
//
//  Created by junmin liu on 12-8-26.
//  Copyright (c) 2012年 idfsoft. All rights reserved.
//

#import "WeiboSignInViewController.h"
#import "MBProgressHUD.h"
#import "WeiboAuthentication.h"

@interface WeiboSignInViewController () <UIWebViewDelegate, MBProgressHUDDelegate>

@end

@implementation WeiboSignInViewController {
  UIWebView *_webView;
  UIBarButtonItem *_cancelButton;
  UIBarButtonItem *_stopButton;
  UIBarButtonItem *_refreshButton;
  
  MBProgressHUD *HUD;
  
  BOOL _closed;
  
  WeiboAuthentication *_authentication;

}

@synthesize authentication = _authentication;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        _stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop:)];
        _refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
        _stopButton.style = UIBarButtonItemStylePlain;
        _refreshButton.style = UIBarButtonItemStylePlain;
    }
    return self;
}

- (void)cancel:(id)sender {
  //
  [self closeWithCompletion:^{
    //
    if ([self.delegate respondsToSelector:@selector(didCancelled)]) {
      [self.delegate performSelector:@selector(didCancelled)];
    }
  }];
}

- (void)closeWithCompletion:(void (^)(void)) cmpltn {
  //
  [HUD hide:YES];
  _closed = YES;
  [self dismissViewControllerAnimated:YES completion:cmpltn];
}

- (void)stop:(id)sender {
    
}

- (void)refresh:(id)sender {
  _closed = NO;
  NSURL *url = [NSURL URLWithString:self.authentication.authorizeRequestUrl];
  NSLog(@"request url: %@", url);
  NSURLRequest *request =[NSURLRequest requestWithURL:url
                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                      timeoutInterval:60.0];
  [_webView loadRequest:request];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
  _webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
  | UIViewAutoresizingFlexibleTopMargin
  | UIViewAutoresizingFlexibleRightMargin
  | UIViewAutoresizingFlexibleBottomMargin
  | UIViewAutoresizingFlexibleWidth
  | UIViewAutoresizingFlexibleHeight;
  _webView.delegate = self;
  [self.view addSubview:_webView];
  
  NSString *html = [NSString stringWithFormat:@"<html><body><div align=center>%@</div></body></html>", @"加载中..."/*NSLocalizedString(@"SignInWebView_InitialMessageHTMLString", @"InitialMessageHTMLString")*/];
  [_webView loadHTMLString:html baseURL:nil];
  
  self.navigationItem.leftBarButtonItem = _cancelButton;
  self.navigationItem.rightBarButtonItem = _refreshButton;
  
  [self refresh:nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  _webView = nil;
  [HUD hide:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	self.title = @"加载中...";//NSLocalizedString(@"WebView_Loading", @"Loading");
  self.navigationItem.rightBarButtonItem = _stopButton;
  
  if (!HUD) {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"加载中...";//NSLocalizedString(@"WebView_Loading", @"Loading");
    [HUD show:YES];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
  self.navigationItem.rightBarButtonItem = _refreshButton;
  [HUD hide:YES];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
  if (error.code != NSURLErrorCancelled && !_closed) {
    self.title = @"网页加载失败";//NSLocalizedString(@"WebView_FailedToLoad", @"Failed to load web page");
    self.navigationItem.rightBarButtonItem = _refreshButton;
    HUD.labelText = @"网页加载失败";//NSLocalizedString(@"WebView_FailedToLoad", @"Failed to load web page");
    [HUD hide:YES afterDelay:2];
  }
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
  
  if (range.location != NSNotFound) {
    NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
    NSLog(@"code: %@", code);
    
    [self closeWithCompletion:^{
      if ([self.delegate respondsToSelector:@selector(didReceiveAuthorizeCode:)]) {
        [self.delegate performSelector:@selector(didReceiveAuthorizeCode:) withObject:code];
      }
    }];
  }
  
  return YES;
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end

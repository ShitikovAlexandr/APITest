//
//  LoginViewController.m
//  APITest
//
//  Created by MacUser on 17.05.16.
//  Copyright © 2016 ShitikovAlexandr. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation LoginViewController

- (id) initWhithCompletioBlock: (LoginCompletionBlock) completionBlock{

    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
   
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString = @"https://oauth.vk.com/authorize?"
                           "client_id=4199692&"
                           "scope=140310&" // +2 +4 +16 +131072 +1024 +8192 = 140310
                           //"redirect_uri=hello.there&"
                            "redirect_uri=https://oauth.vk.com/blank.html&"
                           "display=mobile&"
                           "v=5.52&"
                           "response_type=token";
    
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    self.webView.delegate = nil;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound) {
        
        AccessToken* token = [[AccessToken alloc] init];
        
        NSString* query =  [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.token = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES completion: nil];
        
        return NO;
    }
    
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

#pragma mark - Actions

- (void) actionCancel : (UIBarButtonItem*) item {
    
    if (self.completionBlock) {
        
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion: nil];
}



@end

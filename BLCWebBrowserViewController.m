//
//  UIView+BLCWebBrowserViewController.m
//  blocbrowser
//
//  Created by RH Blanchfield on 3/6/15.
//  Copyright (c) 2015 bloc. All rights reserved.
//


#import "BLCWebBrowserViewController.h"
#import "BLCAwesomeFloatingToolbar.h"


#define kBLCWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kBLCWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kBLCWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kBLCWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface BLCWebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate, BLCAwesomeFloatingToolbarDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UITextField *textField;
//@property (strong, nonatomic) UIButton *backButton;
//@property (strong, nonatomic) UIButton *forwardButton;
//@property (strong, nonatomic) UIButton *reloadButton;
//@property (strong, nonatomic) UIButton *stopButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) BLCAwesomeFloatingToolbar *awesomeToolbar;
@property (nonatomic, assign) NSUInteger frameCount;
@property (assign, nonatomic) BOOL isLoading;


@end

@implementation BLCWebBrowserViewController

#pragma mark - UIViewController

- (void)loadView {
    UIView *mainView = [UIView new];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    //[mainView addSubview:self.webView];
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@" Write Here", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    
    [self.webView setBackgroundColor:[UIColor blackColor]];
    self.awesomeToolbar = [[BLCAwesomeFloatingToolbar alloc] initWithFourTitles:@[kBLCWebBrowserBackString, kBLCWebBrowserForwardString, kBLCWebBrowserStopString, kBLCWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
    [mainView addSubview:self.textField];
    [mainView addSubview:self.webView];
    [mainView addSubview:self.awesomeToolbar];
 
        //[mainView addSubview:subview];
    self.view = mainView;
    }
    

    
    


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    static CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    //[self.view addSubview:self.webView];
   self.awesomeToolbar.frame = CGRectMake(20, 100, 280, 60);
    [self.awesomeToolbar setUserInteractionEnabled:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    NSString *typedURL = textField.text;
    
    if ([typedURL rangeOfString:@"."].location != NSNotFound) {
        typedURL = textField.text;
    }else{
        typedURL = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", textField.text];
    }
    
    //   int spaceIsThere = [[typedURL componentsSeparatedByString:@" "] count];
    //   if (spaceIsThere != 0) {
    //       typedURL = [NSString stringWithFormat:@"http://www.onet.pl"];
    //   }
    
    NSURL *URL = [NSURL URLWithString:typedURL];
    
    if (!URL.scheme) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",typedURL]];
    }
    
    if (URL) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:urlRequest];
    }
    return NO;
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"okey button") otherButtonTitles:nil, nil];
    [alert show];
    [self updateButtonsAndTitle];
    [self.webView stopLoading];
    
}

-(void) updateButtonsAndTitle {
    NSString *webSiteTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.tile"];
    if (webSiteTitle) {
        self.navigationItem.title = webSiteTitle;
    }else{
        self.navigationItem.title = self.webView.request.URL.absoluteString;
    }
    
  
    //self.reloadButton.enabled = self.webView.request.URL && self.frameCount == 0;;
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:kBLCWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:kBLCWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:[self.webView isLoading] forButtonWithTitle:kBLCWebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webView.request.URL && self.frameCount == 0 forButtonWithTitle:kBLCWebBrowserRefreshString];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.isLoading = YES;
    [self updateButtonsAndTitle];
    [self.activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.isLoading = NO;
    [self updateButtonsAndTitle];
    [self.activityIndicator stopAnimating];
}

- (void) resetWebView {
    [self.webView removeFromSuperview];
    
    UIWebView *newWebView = [[UIWebView alloc] init];
    newWebView.delegate = self;
    [self.view addSubview:newWebView];
    
    self.webView = newWebView;
    
    self.textField.text = nil;
    [self updateButtonsAndTitle];
}
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title
{
    if([title isEqualToString:kBLCWebBrowserBackString])
    {
        [self.webView goBack];
    }
    else if([title isEqualToString:kBLCWebBrowserRefreshString])
    {
        [self.webView reload];
    }
    else if([title isEqualToString:kBLCWebBrowserForwardString])
    {
        [self.webView goForward];
    }
    else if([title isEqualToString:kBLCWebBrowserStopString])
    {
        [self.webView stopLoading];
    }
    
}
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)point
{
    NSLog(@"Hello");
}
    @end


//
//  UIView+BLCWebBrowserViewController.h
//  blocbrowser
//
//  Created by RH Blanchfield on 3/6/15.
//  Copyright (c) 2015 bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCWebBrowserViewController : UIViewController

/**
 Replaces the web view with a fresh one, erasing all history. Also updates the URL field and toolbar buttons appropriately.
 */
- (void) resetWebView;


@end
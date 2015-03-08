//
//  BLCAwesomeFloatingToolbar.h
//  blocbrowser
//
//  Created by RH Blanchfield on 3/6/15.
//  Copyright (c) 2015 bloc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)point;
//- (void) floatingToolbar:(BLCAwsomeFloatingToolbar *)toolbar didPinchWithOffset:(CGFloat)offset;
//- (void) floatingToolbar:(BLCAwsomeFloatingToolbar *)toolbar didLongPressWithOffset:(CGPoint)offset;

- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didPinchWithOffset:(CGFloat *)offset;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didLongPressWithOffset:(CGPoint *)title;

@end

@interface BLCAwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;

@end
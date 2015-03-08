//
//  BLCAwesomeFloatingToolbar.m
//  blocbrowser
//
//  Created by RH Blanchfield on 3/6/15.
//  Copyright (c) 2015 bloc. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"




@interface BLCAwesomeFloatingToolbar () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;

@property (nonatomic, weak) UILabel *currentLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation BLCAwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
       
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            label.tag = currentTitleIndex;
            [labelsArray addObject:label];
            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
            self.tapGesture.numberOfTapsRequired = 1;
            [label addGestureRecognizer:self.tapGesture];

        }
        
        self.labels = [NSArray arrayWithArray:labelsArray];
        
        for (UILabel *thisLabel in self.labels) {
            
            
           [self addSubview:thisLabel];
        }
      //  [self setUserInteractionEnabled:YES];
      //  self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
      //  self.tapGesture.delegate = self;
      //  self.tapGesture.numberOfTapsRequired = 1;
      //  [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
    }
    
    return self;
}

- (void) layoutSubviews {
    // set the frames for the 4 labels
    
    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        // adjust labelX and labelY for each label
        if (currentLabelIndex < 2) {
            // 0 or 1, so on top
            labelY = 0;
        } else {
            // 2 or 3, so on bottom
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
            // 0 or 2, so on the left
            labelX = 0;
        } else {
            // 1 or 3, so on the right
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
       
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

#pragma mark - Touch Handling

/*- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UILabel *label = (UILabel *)touch.view;
   
    
        UIView *subview = [self hitTest:location withEvent:event];
     NSLog(@"TAG %d",label.tag);
    return label;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    NSLog(@"%@",[touch.view.subviews description]);
    if(touch.view == self.currentLabel)
    {
     NSLog(@"Balle%@",touch.view);
    }
    UILabel *label = [self labelFromTouches:touches withEvent:event];
   
    //self.currentLabel = label;
    //self.currentLabel.alpha = 0.5;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel != label) {
        // The label being touched is no longer the initial label
        self.currentLabel.alpha = 1;
    } else {
        // The label being touched is the initial label
        self.currentLabel.alpha = 0.5;
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLabel == label) {
        NSLog(@"Label tapped: %@", self.currentLabel.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLabel.text];
        }
    }
    
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentLabel.alpha = 1;
    self.currentLabel = nil;
}
*/
#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}

#pragma mark - Gesture Recognizers

- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    NSLog(@"%d",recognizer.view.tag);
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        //CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = recognizer.view;
        
        if ([self.labels containsObject:(UILabel *)tappedView]) {
            NSLog(@"Hello");
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }
    
}


- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        //self.center = translation;
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

@end
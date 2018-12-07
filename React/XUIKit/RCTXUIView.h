/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

#import "NSView+XUIKit.h"

@interface RCTXUIView : NSView

- (void)setNeedsLayout;
- (CGSize)sizeThatFits:(CGSize)size;

- (void)didMoveToWindow;
- (void)layoutSubviews;

- (void)insertSubview:(RCTXUIView *)view atIndex:(NSInteger)index;

- (RCTXUIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event;

@property(nonatomic, copy) NSColor *backgroundColor;
@property(nonatomic) CGPoint center;
@property(nonatomic) BOOL clipsToBounds;

@property(readonly, assign) RCTXUIView *superview;
@property(nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

@end

/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */
#import "RCTXUIView.h"

@implementation RCTXUIView

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    _userInteractionEnabled = YES;
  }
  return self;
}

- (void)setNeedsLayout
{
  [self layout];
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return self.intrinsicContentSize;
}

- (void)didMoveToWindow
{
  [self viewDidMoveToWindow];
}

- (void)layoutSubviews
{
  [self layout];
}

- (void)insertSubview:(RCTXUIView *)view atIndex:(NSInteger)index
{
  [view removeFromSuperview];

  NSMutableArray *subviews = [self.subviews mutableCopy];
  [subviews insertObject:view atIndex:index];
  self.subviews = subviews;
}

- (RCTXUIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event
{
  if (!self.userInteractionEnabled) {
    return nil;
  }

  // |event| is not supported
  return (RCTXUIView *)[self hitTest:point];
}

- (NSColor *)backgroundColor
{
  return [NSColor colorWithCGColor:self.layer.backgroundColor];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
  self.layer.backgroundColor = backgroundColor.CGColor;
}

- (CGPoint)center
{
  return CGPointMake(NSMidX(self.frame), NSMidY(self.frame));
}

- (void)setCenter:(CGPoint)center
{
  // TODO(kudo)
}

- (BOOL)clipsToBounds
{
  return self.layer.masksToBounds;
}

- (void)setClipsToBounds:(BOOL)clipsToBounds
{
  self.layer.masksToBounds = clipsToBounds;
}

- (RCTXUIView *)superview
{
  return super.superview;
}

@end

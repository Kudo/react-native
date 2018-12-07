/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUIScrollView.h"

@implementation RCTXUIScrollView

// TODO(kudo)
@synthesize delegate;
@synthesize delaysContentTouches;
@synthesize clipsToBounds;
@synthesize contentSize;
@synthesize canCancelContentTouches;
@synthesize decelerationRate;
@synthesize keyboardDismissMode;
@synthesize pagingEnabled;
@synthesize scrollsToTop;
@synthesize scrollIndicatorInsets;

@synthesize scrollEnabled;

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.scrollEnabled = YES;
  }
  return self;
}

- (void)scrollWheel:(NSEvent *)event
{
  if (self.scrollEnabled)
    [super scrollWheel:event];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
  if (animated) {
    NSClipView *clipView = self.contentView;
    NSPoint scrollOrigin = rect.origin;
    scrollOrigin.y += MAX(0, (NSHeight(rect) - NSHeight(clipView.frame)) * 0.5f);
    [self setContentOffset:scrollOrigin animated:animated];
  } else {
    [self scrollRectToVisible:rect];
  }
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
  if (animated) {
    NSClipView *clipView = self.contentView;
    [self flashScrollers];
    [[clipView animator] setBoundsOrigin:contentOffset];
  } else {
    [self.documentView scrollPoint:contentOffset];
  }
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated
{
  if (animated) {
    [[self animator] magnifyToFitRect:rect];
  } else {
    [self magnifyToFitRect:rect];
  }
}

- (void)flashScrollIndicators
{
  [self flashScrollers];
}

- (NSEdgeInsets)contentInset
{
  return self.contentInsets;
}

- (void)setContentInset:(NSEdgeInsets)contentInset
{
  self.contentInsets = contentInset;
}

- (CGPoint)contentOffset
{
  return self.documentVisibleRect.origin;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
  // TODO(kudo):
}

- (NSPanGestureRecognizer *)panGestureRecognizer
{
  // TODO(kudo):
  return nil;
}

- (BOOL)wantsDefaultClipping
{
  return self.clipsToBounds;
}

- (BOOL)bounces
{
  return self.verticalScrollElasticity != NSScrollElasticityNone &&
  self.horizontalScrollElasticity != NSScrollElasticityNone;
}

- (void)setBounces:(BOOL)bounces
{
  if (bounces) {
    self.verticalScrollElasticity = NSScrollElasticityAutomatic;
    self.horizontalScrollElasticity = NSScrollElasticityAutomatic;
  } else {
    self.verticalScrollElasticity = NSScrollElasticityNone;
    self.horizontalScrollElasticity = NSScrollElasticityNone;
  }
}

- (BOOL)alwaysBounceVertical
{
  return self.verticalScrollElasticity == NSScrollElasticityAllowed;
}

- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical
{
  self.verticalScrollElasticity = alwaysBounceVertical ?
  NSScrollElasticityAllowed : NSScrollElasticityAutomatic;
}

- (BOOL)alwaysBounceHorizontal
{
  return self.horizontalScrollElasticity == NSScrollElasticityAllowed;
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal
{
  self.horizontalScrollElasticity = alwaysBounceHorizontal ?
  NSScrollElasticityAllowed : NSScrollElasticityAutomatic;;
}

- (BOOL)bouncesZoom
{
  return self.allowsMagnification;
}

- (void)setBouncesZoom:(BOOL)bouncesZoom
{
  self.allowsMagnification = bouncesZoom;
}

- (BOOL)isDirectionalLockEnabled
{
  return self.usesPredominantAxisScrolling;
}

- (void)setDirectionalLockEnabled:(BOOL)directionalLockEnabled
{
  self.usesPredominantAxisScrolling = directionalLockEnabled;
}

- (UIScrollViewIndicatorStyle)indicatorStyle
{
  return (UIScrollViewIndicatorStyle) self.scrollerKnobStyle;
}

- (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle
{
  self.scrollerKnobStyle = (NSScrollerKnobStyle) indicatorStyle;
}

- (CGFloat)zoomScale
{
  return self.magnification;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
  self.magnification = zoomScale;
}

- (CGFloat)minimumZoomScale
{
  return self.minMagnification;
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale
{
  self.minMagnification = minimumZoomScale;
}

- (CGFloat)maximumZoomScale
{
  return self.maxMagnification;
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale
{
  self.maxMagnification = maximumZoomScale;
}

- (BOOL)showsHorizontalScrollIndicator
{
  return self.hasHorizontalScroller;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
  self.hasHorizontalScroller = showsHorizontalScrollIndicator;
}

- (BOOL)showsVerticalScrollIndicator
{
  return self.hasVerticalScroller;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
  self.hasVerticalScroller = showsVerticalScrollIndicator;
}
@end

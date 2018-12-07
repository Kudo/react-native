/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

#import "RCTXUIScrollViewDelegate.h"

typedef NS_ENUM(NSInteger, UIScrollViewIndicatorStyle) {
  UIScrollViewIndicatorStyleDefault = NSScrollerKnobStyleDefault,
  UIScrollViewIndicatorStyleBlack = NSScrollerKnobStyleDark,
  UIScrollViewIndicatorStyleWhite = NSScrollerKnobStyleLight,
};

typedef NS_ENUM(NSInteger, UIScrollViewKeyboardDismissMode) {
  UIScrollViewKeyboardDismissModeNone,
  UIScrollViewKeyboardDismissModeOnDrag,      // dismisses the keyboard when a drag begins
  UIScrollViewKeyboardDismissModeInteractive, // the keyboard follows the dragging touch off screen, and may be pulled upward again to cancel the dismiss
};

@interface RCTXUIScrollView : NSScrollView

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;
- (void)flashScrollIndicators;

@property(nullable, nonatomic, weak) id<UIScrollViewDelegate> delegate;
@property(nonatomic) NSEdgeInsets contentInset;
@property(nonatomic) NSEdgeInsets scrollIndicatorInsets;
@property(nonatomic) CGPoint contentOffset;
@property(nonatomic) CGSize contentSize;
@property(nonatomic, readonly) NSPanGestureRecognizer *panGestureRecognizer;

@property(nonatomic) BOOL delaysContentTouches;
@property(nonatomic) BOOL clipsToBounds;

@property(nonatomic) BOOL bounces;
@property(nonatomic) BOOL alwaysBounceHorizontal;
@property(nonatomic) BOOL alwaysBounceVertical;
@property(nonatomic) BOOL bouncesZoom;
@property(nonatomic) BOOL canCancelContentTouches;
@property(nonatomic) CGFloat decelerationRate;
@property(nonatomic, getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;
@property(nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
@property(nonatomic) UIScrollViewKeyboardDismissMode keyboardDismissMode;
@property(nonatomic) CGFloat zoomScale;
@property(nonatomic) CGFloat minimumZoomScale;
@property(nonatomic) CGFloat maximumZoomScale;

@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@property(nonatomic, getter=isPagingEnabled) BOOL pagingEnabled;
@property(nonatomic) BOOL scrollsToTop;

@property(nonatomic) BOOL showsHorizontalScrollIndicator;
@property(nonatomic) BOOL showsVerticalScrollIndicator;


@end

/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#if TARGET_OS_OSX

#import <AppKit/AppKit.h>

#import "RCTXUIGraphicsAdditions.h"
#import "RCTXUIDeviceAdditions.h"
#import "RCTXUIGeometryAdditions.h"

#import "RCTXUIView.h"
#import "RCTXUIView+UIViewAnimationWithBlocks.h"
#import "RCTXUILabel.h"
#import "RCTXUISwitch.h"
#import "RCTXUIActivityIndicatorView.h"
#import "RCTXUICADisplayLink.h"
#import "RCTXUIScrollView.h"
#import "RCTXUITableView.h"
#import "RCTXUITableViewCell.h"
#import "RCTXUIApplication.h"
#import "RCTXUIScrollViewDelegate.h"

#import "NSWindow+XUIKit.h"
#import "NSScreen+XUIKit.h"
#import "NSView+XUIKit.h"
#import "NSViewController+XUIKit.h"
#import "NSImage+XUIKit.h"
#import "NSControl+XUIKit.h"
#import "NSSegmentedControl+XUIKit.h"
#import "NSDatePicker+XUIKit.h"
#import "NSSlider+XUIKit.h"
#import "NSProgressIndicator+XUIKit.h"
#import "NSIndexPath+XUIKit.h"
#import "NSGestureRecognizer+XUIKit.h"

#elif TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_OSX
typedef NSColor UIColor;
typedef RCTXUIApplication UIApplication;
typedef NSWindow UIWindow;
#define UIWindowLevel NSWindowLevel
typedef NSViewController UIViewController;
#define UIView RCTXUIView
typedef RCTXUIScrollView UIScrollView;
typedef NSScreen UIScreen;
typedef NSImage UIImage;

typedef NSEdgeInsets UIEdgeInsets;
#define UIEdgeInsetsMake NSEdgeInsetsMake
#define UIEdgeInsetsZero NSEdgeInsetsZero

NS_INLINE CGRect NSEdgeInsetsInsetRect(NSRect rect, NSEdgeInsets insets) {
  rect.origin.x += insets.left;
  rect.origin.y += insets.top;
  rect.size.width -= (insets.left + insets.right);
  rect.size.height -= (insets.top + insets.bottom);
  return rect;
}
#define UIEdgeInsetsInsetRect NSEdgeInsetsInsetRect

typedef NS_OPTIONS(NSUInteger, UIAutoresizingMaskOptions) {
  UIViewAutoresizingFlexibleWidth = NSViewWidthSizable,
  UIViewAutoresizingFlexibleHeight = NSViewHeightSizable,
};

typedef NS_ENUM(NSInteger, UIUserInterfaceLayoutDirection) {
  UIUserInterfaceLayoutDirectionLeftToRight = NSUserInterfaceLayoutDirectionLeftToRight,
  UIUserInterfaceLayoutDirectionRightToLeft = NSUserInterfaceLayoutDirectionRightToLeft,
};

typedef NSSegmentedControl UISegmentedControl;
typedef NSEventModifierFlags UIKeyModifierFlags;
typedef NSEvent UIKeyCommand;
typedef NSEvent UIEvent;
// typedef NSEvent UIControlEvent;
typedef NSGestureRecognizer UIGestureRecognizer;

typedef NSDatePicker UIDatePicker;
typedef NSSlider UISlider;
typedef NSProgressIndicator UIProgressView;

typedef RCTXUITableView UITableView;
typedef RCTXUITableViewCell UITableViewCell;
#define UITableViewDataSource NSTableViewDataSource
#define UITableViewDelegate NSTableViewDelegate

typedef NSPanGestureRecognizer UIPanGestureRecognizer;
typedef NSClickGestureRecognizer UITapGestureRecognizer;
#define UIGestureRecognizerDelegate NSGestureRecognizerDelegate

// TODO(kudo):
typedef NSAlert UIAlertController;

typedef NSFont UIFont;
#define UIFontWeightTrait NSFontWeightTrait
typedef RCTXUILabel UILabel;
typedef RCTXUISwitch UISwitch;
typedef RCTXUIActivityIndicatorView UIActivityIndicatorView;

typedef RCTXUICADisplayLink CADisplayLink;

NSString *const UIKeyboardWillShowNotification = @"UIKeyboardWillShowNotification";
NSString *const UIKeyboardDidShowNotification = @"UIKeyboardDidShowNotification";
NSString *const UIKeyboardWillHideNotification = @"UIKeyboardWillHideNotification";
NSString *const UIKeyboardDidHideNotification = @"UIKeyboardDidHideNotification";
NSString *const UIKeyboardWillChangeFrameNotification = @"UIKeyboardWillChangeFrameNotification";

NSString *const UIKeyboardFrameBeginUserInfoKey = @"UIKeyboardFrameBeginUserInfoKey";
NSString *const UIKeyboardFrameEndUserInfoKey = @"UIKeyboardFrameEndUserInfoKey";
NSString *const UIKeyboardAnimationDurationUserInfoKey = @"UIKeyboardAnimationDurationUserInfoKey";
NSString *const UIKeyboardAnimationCurveUserInfoKey = @"UIKeyboardAnimationCurveUserInfoKey";

#define UIKeyModifierCommand NSEventModifierFlagCommand

#endif

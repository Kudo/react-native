/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, UIViewContentMode) {
  UIViewContentModeScaleToFill,
  UIViewContentModeScaleAspectFit,
  UIViewContentModeScaleAspectFill,
  UIViewContentModeRedraw,
  UIViewContentModeCenter,
  UIViewContentModeTop,
  UIViewContentModeBottom,
  UIViewContentModeLeft,
  UIViewContentModeRight,
  UIViewContentModeTopLeft,
  UIViewContentModeTopRight,
  UIViewContentModeBottomLeft,
  UIViewContentModeBottomRight,
};


NSData *UIImagePNGRepresentation(NSImage *image);
NSData *UIImageJPEGRepresentation(NSImage *image, float quality);

void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);

void UIGraphicsPushContext(CGContextRef ctx);
void UIGraphicsPopContext();

CGContextRef UIGraphicsGetCurrentContext();

NSImage *UIGraphicsGetImageFromCurrentImageContext();

void UIGraphicsEndImageContext();

CGImageRef RCTGetCGImageRef(NSImage *image);


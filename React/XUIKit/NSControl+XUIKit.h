/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
  UIControlEventTouchDown           = 1 <<  0,
  UIControlEventTouchDownRepeat     = 1 <<  1,
  UIControlEventTouchDragInside     = 1 <<  2,
  UIControlEventTouchDragOutside    = 1 <<  3,
  UIControlEventTouchDragEnter      = 1 <<  4,
  UIControlEventTouchDragExit       = 1 <<  5,
  UIControlEventTouchUpInside       = 1 <<  6,
  UIControlEventTouchUpOutside      = 1 <<  7,
  UIControlEventTouchCancel         = 1 <<  8,

  UIControlEventValueChanged        = 1 << 12,

  UIControlEventEditingDidBegin     = 1 << 16,
  UIControlEventEditingChanged      = 1 << 17,
  UIControlEventEditingDidEnd       = 1 << 18,
  UIControlEventEditingDidEndOnExit = 1 << 19,

  UIControlEventAllTouchEvents      = 0x00000FFF,
  UIControlEventAllEditingEvents    = 0x000F0000,
  UIControlEventApplicationReserved = 0x0F000000,
  UIControlEventSystemReserved      = 0xF0000000,
  UIControlEventAllEvents           = 0xFFFFFFFF
};

typedef NS_OPTIONS(NSUInteger, UIControlState) {
  UIControlStateNormal               = 0,
  UIControlStateHighlighted          = 1 << 0,
  UIControlStateDisabled             = 1 << 1,
  UIControlStateSelected             = 1 << 2,
  UIControlStateApplication          = 0x00FF0000,
  UIControlStateReserved             = 0xFF000000
};

@interface NSControl (XUIKit)

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

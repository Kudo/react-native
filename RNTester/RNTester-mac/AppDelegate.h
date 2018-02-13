//
//  AppDelegate.h
//  RNTester-mac
//
//  Created by Kudo Chien on 12/02/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RCTBridge;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, readonly) RCTBridge *bridge;

@end


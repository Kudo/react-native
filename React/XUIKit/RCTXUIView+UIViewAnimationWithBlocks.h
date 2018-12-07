//
//  Taken from
//  https://github.com/BigZaphod/Chameleon/blob/master/UIKit/Classes/UIViewAnimationGroup.m


#import <AppKit/AppKit.h>

#import "RCTXUIView.h"

typedef NS_ENUM(NSInteger, UIViewAnimationTransition) {
  UIViewAnimationTransitionNone,
  UIViewAnimationTransitionFlipFromLeft,
  UIViewAnimationTransitionFlipFromRight,
  UIViewAnimationTransitionCurlUp,
  UIViewAnimationTransitionCurlDown,
};

typedef NS_ENUM(NSInteger, UIViewAnimationGroupTransition) {
  UIViewAnimationGroupTransitionNone,
  UIViewAnimationGroupTransitionFlipFromLeft,
  UIViewAnimationGroupTransitionFlipFromRight,
  UIViewAnimationGroupTransitionCurlUp,
  UIViewAnimationGroupTransitionCurlDown,
  UIViewAnimationGroupTransitionFlipFromTop,
  UIViewAnimationGroupTransitionFlipFromBottom,
  UIViewAnimationGroupTransitionCrossDissolve,
};

typedef NS_ENUM(NSUInteger, UIViewAnimationOptions) {
  UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
  UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
  UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
  UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
  UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
  UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
  UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
  UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
  UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing

  UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
  UIViewAnimationOptionCurveEaseIn               = 1 << 16,
  UIViewAnimationOptionCurveEaseOut              = 2 << 16,
  UIViewAnimationOptionCurveLinear               = 3 << 16,

  UIViewAnimationOptionTransitionNone            = 0 << 20, // default
  UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
  UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
  UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
  UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
  UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
  UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
  UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
};

typedef NS_ENUM(NSInteger, UIViewAnimationCurve) {
  UIViewAnimationCurveEaseInOut,         // slow at beginning and end
  UIViewAnimationCurveEaseIn,            // slow at beginning
  UIViewAnimationCurveEaseOut,           // slow at end
  UIViewAnimationCurveLinear
};

extern BOOL UIViewAnimationOptionIsSet(UIViewAnimationOptions options, UIViewAnimationOptions option);

@interface RCTXUIView (UIViewAnimationWithBlocks)

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion; // delay = 0.0, options = 0

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations; // delay = 0.0, options = 0, completion = NULL

+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity
                    options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations
                 completion:(void (^ __nullable)(BOOL finished))completion;

+ (void)beginAnimations:(NSString *)animationID context:(void *)context;
+ (void)commitAnimations;
+ (BOOL)areAnimationsEnabled;
+ (void)setAnimationsEnabled:(BOOL)enabled;

@end

@interface RCTXUIViewBlockAnimationDelegate : NSObject {
  void (^_completion)(BOOL finished);
  BOOL _ignoreInteractionEvents;
}

@property (nonatomic, copy) void (^completion)(BOOL finished);
@property (nonatomic, assign) BOOL ignoreInteractionEvents;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished;

@end

@interface UIViewAnimationGroup : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) void *context;
@property (nonatomic, copy) void (^completionBlock)(BOOL finished);
@property (nonatomic, assign) BOOL allowUserInteraction;
@property (nonatomic, assign) BOOL beginsFromCurrentState;
@property (nonatomic, assign) UIViewAnimationCurve curve;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) SEL didStopSelector;
@property (nonatomic, assign) SEL willStartSelector;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL repeatAutoreverses;
@property (nonatomic, assign) float repeatCount;
@property (nonatomic, assign) UIViewAnimationGroupTransition transition;

- (id)initWithAnimationOptions:(UIViewAnimationOptions)options;

- (id)actionForView:(RCTXUIView *)view forKey:(NSString *)keyPath;

- (void)setAnimationBeginsFromCurrentState:(BOOL)beginFromCurrentState;
- (void)setAnimationCurve:(UIViewAnimationCurve)curve;
- (void)setAnimationDelay:(NSTimeInterval)delay;
- (void)setAnimationDelegate:(id)delegate;			// retained! (also true of the real UIKit)
- (void)setAnimationDidStopSelector:(SEL)selector;
- (void)setAnimationDuration:(NSTimeInterval)duration;
- (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;
- (void)setAnimationRepeatCount:(float)repeatCount;
- (void)setAnimationWillStartSelector:(SEL)selector;

- (void)commit;

@end

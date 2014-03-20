//
//  GRKContainerViewController.h
//
//  Created by Levi Brown on November 23, 2013.
//  Copyright (c) 2013, 2014 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import <UIKit/UIKit.h>

/**
 *  The default animation duration for the transition to the new view controller.
 */
extern NSTimeInterval const kDefaultAnimationDuration;

///
/// @name GRKContainerViewController
///

@interface GRKContainerViewController : UIViewController

/**
 *  The current view controller. Changes to this property will not be animated.
 */
@property (nonatomic,strong) UIViewController *viewController;

/**
 *  The animation duration to use for the transition animation (if applicable). Defaults to `kDefaultAnimationDuration`.
 *  @see kDefaultAnimationDuration
 */
@property (nonatomic,assign) NSTimeInterval transitionAnimationDuration;

/**
 *  Set the currently displayed view controller with an optional cross fade animation and completion handler.
 *
 *  @param viewController The new view controler to be displayed.
 *  @param animated       If YES then a simple cross fade animation will be applied during the tranistion from the current view controller to the new view controller.
 *  @param completion     A block to be called once the new view controller is displayed (after any animations). This can be `nil`.
 */
- (void)setViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^)(UIViewController *viewController))completion;

@end

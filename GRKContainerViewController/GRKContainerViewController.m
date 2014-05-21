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

#import "GRKContainerViewController.h"

NSTimeInterval const kDefaultAnimationDuration = 0.5f;

@implementation GRKContainerViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _transitionAnimationDuration = kDefaultAnimationDuration;
}

#pragma mark - API Implementation

- (void)setViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^)(UIViewController *viewController))completion
{
    //Ensure the view is loaded
    [self view];
    
    //We will use a simple cross fade animation, as indicated
    NSTimeInterval duration = animated ? self.transitionAnimationDuration : 0.0f;
    
    // We're fading out views, so make sure they're not invisible when we start.
    self.viewController.view.alpha = 1.0f;
    viewController.view.alpha = 1.0f;
    
    //Add the new view controller to the view and view controller hierarchies
    if (viewController)
    {
        [self addChildViewController:viewController];
        
        // Add the new view below the current view, and then fade out the current view.
        [self.view addSubview:viewController.view];
        [self.view insertSubview:viewController.view belowSubview:self.viewController.view];
        [viewController didMoveToParentViewController:self];

        //Setup constraints to keep the new view pinned to our size.
        UIView *containedView = viewController.view;
        containedView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[containedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containedView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[containedView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containedView)]];
    }
    
    // Hold onto the old controller, and set the new one.
    UIViewController *oldViewController = self.viewController;
    _viewController = viewController;
    
    [UIView animateWithDuration:duration animations:^{
        // Animate away the old controller view.
        oldViewController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Quick transitions can leave us trying to remove the view that has just been added. Only remove it if its not the same controller.
        if (_viewController != oldViewController) {
            [oldViewController willMoveToParentViewController:nil];
            [oldViewController.view removeFromSuperview];
            [oldViewController removeFromParentViewController];
        }
        
        if (completion)
        {
            //Call the completion block with the new view controller
            completion(viewController);
        }
    }];
}

#pragma mark - Accessors

- (void)setViewController:(UIViewController *)viewController
{
    [self setViewController:viewController animated:NO completion:nil];
}

@end

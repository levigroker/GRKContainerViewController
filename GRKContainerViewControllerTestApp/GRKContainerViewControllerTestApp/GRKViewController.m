//
//  GRKViewController.m
//  GRKContainerViewControllerTestApp
//
//  Created by Levi Brown on 3/20/14.
//  Copyright (c) 2014 Levi Brown. All rights reserved.
//

#import "GRKViewController.h"
#import "GRKContainerViewController.h"
#import "GRKFirstViewController.h"
#import "GRKSecondViewController.h"
#import "GRKThirdViewController.h"

static NSString * const kSegueBody = @"body";

typedef NS_ENUM(NSInteger, BodyContent) {
    BodyContentZero = 0,
    BodyContentOne,
    BodyContentTwo,
    BodyContentCount //Always last in the enum
};

@interface GRKViewController ()

@property (nonatomic,weak) GRKContainerViewController *bodyContainerViewController;

@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentSelected:(UISegmentedControl *)sender;
- (IBAction)buttonAction:(UIButton *)sender;

@end

@implementation GRKViewController

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NOTE: The identifier for the segue to embed the GRKContainerViewController needs to be set (in this case to 'kSegueBody') in the Storyboard.
    NSString *identifier = segue.identifier;
    if ([identifier isEqual:kSegueBody])
    {
        //Get a reference to the body container view controller and configure it as it gets embedded.
        id obj = segue.destinationViewController;
        if ([obj isKindOfClass:GRKContainerViewController.class])
        {
            self.bodyContainerViewController = (GRKContainerViewController *)obj;
            [self setBodyContentWithIndex:self.segmentedControl.selectedSegmentIndex animated:YES];
        }
        else
        {
            NSLog(@"ERROR: Seque '%@' is of unexpected type: %@", identifier, obj);
        }
    }
}

#pragma mark - Actions

- (IBAction)segmentSelected:(UISegmentedControl *)sender
{
    NSLog(@"Selected '%@' at index %d.", [sender titleForSegmentAtIndex:sender.selectedSegmentIndex], (int)sender.selectedSegmentIndex);
    [self setBodyContentWithIndex:self.segmentedControl.selectedSegmentIndex animated:YES];
}

- (IBAction)buttonAction:(UIButton *)sender
{
    NSLog(@"Selected '%@' with tag %d.", [sender titleColorForState:UIControlStateNormal], (int)sender.tag);
    [self setBodyContentWithIndex:sender.tag animated:YES];
    self.segmentedControl.selectedSegmentIndex = sender.tag;
}

#pragma mark - Body Content

- (void)setBodyContentWithIndex:(NSInteger)index animated:(BOOL)animated
{
    NSLog(@"Setting body index to %d", (int)index);
    
    UIViewController *viewController = nil;
    
    if (self.bodyContainerViewController)
    {
        //Here we create (or simply configure a cached instance ) the instance of the view controller to be displayed.
        //In this example it is pretty contrived since there's not really a need for three different classes of view
        //controllers but it was done this way to demonstrate the view controllers can be completely different.
        
        switch (index) {
            case BodyContentZero:
            default:
            {
                static GRKFirstViewController *vc = nil;
                if (!vc)
                {
                    //Assumes the view controller class name is the storyboard identifier
                    vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(GRKFirstViewController.class)];
                }
                viewController = vc;
                break;
            }
            case BodyContentOne:
            {
                static GRKSecondViewController *vc = nil;
                if (!vc)
                {
                    //Assumes the view controller class name is the storyboard identifier
                    vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(GRKSecondViewController.class)];
                }
                viewController = vc;
                break;
            }
            case BodyContentTwo:
            {
                //Assumes the view controller class name is the storyboard identifier
                GRKThirdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(GRKThirdViewController.class)];
                viewController = vc;
                break;
            }
        }

        [self.bodyContainerViewController setViewController:viewController animated:animated completion:nil];
    }
}

@end

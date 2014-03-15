//
//  RootViewController.m
//  Auto-Layout Issues
//
//  Created by Sven Herzberg on 15.03.14.
//
//

#import "RootViewController.h"

typedef enum {
    Strategy_None,
    Strategy_AutoresizingMask,
    Strategy_BottomConstraint
    // feel free to fork this repository and add your own strategy
} Strategy;

#define STRATEGY_DEFAULT Strategy_BottomConstraint

/* Strategy_None:
 * No attempt to change anything, does not work anywhere.
 */

/* Strategy_AutoResizingMask:
 * My own solution. Update the autoresisingMask and let iOS do the rest for you.
 * (only works within UINavigationController)
 */

/* Strategy_BottomConstraint:
 * Solution from CEarwood @ http://stackoverflow.com/a/16547378/418244
 * (only works within UINavigationController)
 */

@interface RootViewController ()

@property IBOutlet NSLayoutConstraint* bottomConstraint;
@property Strategy strategy;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.strategy = STRATEGY_DEFAULT;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];

    switch (_strategy) {
        case Strategy_None:
            break;
            
        case Strategy_AutoresizingMask:
            self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case Strategy_BottomConstraint:
            // maybe think about using -viewDidAppear:/viewDidDisappear for adding/removing observers
            [center addObserverForName:UIApplicationWillChangeStatusBarFrameNotification
                                object:nil
                                 queue:nil
                            usingBlock:^(NSNotification *note) {
                                CGRect statusBarFrame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
                                self.bottomConstraint.constant = statusBarFrame.size.height + 100;
                                [self.view setNeedsLayout];
                            }];
            [center addObserverForName:UIApplicationDidChangeStatusBarFrameNotification
                                object:nil
                                 queue:nil
                            usingBlock:^(NSNotification *note) {
                                self.bottomConstraint.constant = 100;
                                [self.view setNeedsLayout];
                            }];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  OrientationChangePosition
//
//  Created by Masrina on 5/22/15.
//  Copyright (c) 2015 Masrina. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) UIView *aContainerView;
@property (nonatomic, weak) UIView *bContainerView;
@property (nonatomic, assign) BOOL touchExited;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, weak) NSTimer *countChangeTimer;
@property (nonatomic, weak) UIButton *theCountButton;
@property (nonatomic, strong) NSArray *horizontalOrientationConstraints;
@property (nonatomic, strong) NSArray *verticalOrientationConstraints;

@end

@implementation ViewController
- (void)invalidateTimer
{
    if (self.countChangeTimer) {
        [self.countChangeTimer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *aContainerView = [self viewWithLabelText:@"A" andBackgroundColor:[UIColor yellowColor]];
    UIView *bContainerView = [self viewWithLabelText:@"B" andBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:aContainerView];
    [self.view addSubview:bContainerView];
    self.aContainerView = aContainerView;
    self.bContainerView = bContainerView;
    
    CGSize viewSize = self.view.bounds.size;
    
    if (viewSize.width > viewSize.height) {
        [self.view addConstraints:self.horizontalOrientationConstraints];
    } else {
        [self.view addConstraints:self.verticalOrientationConstraints];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
- (UIView *)viewWithLabelText:(NSString *)text andBackgroundColor:(UIColor *)color
{
    UIView *aContainerView = [[UIView alloc] init];
    aContainerView.backgroundColor = [UIColor blackColor];
    aContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *aView = [[UIView alloc] init];
    aView.translatesAutoresizingMaskIntoConstraints = NO;
    aView.backgroundColor = color;
    
    UILabel *aLabel = [[UILabel alloc] init];
    aLabel.translatesAutoresizingMaskIntoConstraints = NO;
    aLabel.text = text;
    aLabel.font = [UIFont systemFontOfSize:80];
    
    [aView addSubview:aLabel];
    
    [aContainerView addSubview:aView];
    
    
    NSLayoutConstraint *centerXConstraints = [NSLayoutConstraint constraintWithItem:aView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:aLabel
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0
                                                                           constant:0];
    NSLayoutConstraint *centerYConstraints = [NSLayoutConstraint constraintWithItem:aView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:aLabel
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0
                                                                           constant:0];
    [aContainerView addConstraints:@[centerXConstraints, centerYConstraints]];
    
    
    NSString *hConstraintsFormat = @"V:|-10-[view]-10-|";
    NSString *vConstraintsFormat = @"H:|-10-[view]-10-|";
    
    [aContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hConstraintsFormat
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"view": aView}]];
    [aContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vConstraintsFormat
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"view": aView}]];
    
    return aContainerView;
}

// For ios 8
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSArray *constraintsToDeactivate;
    NSArray *constraintsToActivate;
    
    if (size.width > size.height) {
        constraintsToActivate = self.horizontalOrientationConstraints;
        constraintsToDeactivate = self.verticalOrientationConstraints;
    }else{
        constraintsToActivate = self.verticalOrientationConstraints;
        constraintsToDeactivate = self.horizontalOrientationConstraints;
    }
    
    [NSLayoutConstraint deactivateConstraints:constraintsToDeactivate];
    [NSLayoutConstraint activateConstraints:constraintsToActivate];
    [self.view layoutIfNeeded];
}

// For ios 7
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSArray *constraintsToDeactivate;
    NSArray *constraintsToActivate;
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        constraintsToActivate = self.horizontalOrientationConstraints;
        constraintsToDeactivate = self.verticalOrientationConstraints;
    } else {
        constraintsToActivate = self.verticalOrientationConstraints;
        constraintsToDeactivate = self.horizontalOrientationConstraints;
    }
    [self.view removeConstraints:constraintsToDeactivate];
    [self.view addConstraints:constraintsToActivate];
}
#pragma mark - Getters
//- (NSArray *)horizontalOrientationConstraints{
//    if (!_horizontalOrientationConstraints) {
//        NSLayoutConstraint *equalWidthConstraints = [NSLayoutConstraint constraintWithItem:self.aContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.bContainerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aContainerView][bContainerView]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:@{@"aContainerView":self.aContainerView, @"bContainerView":self.bContainerView}];
//        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aContainerView]|" options:0 metrics:nil views:@{@"aContainerView":self.aContainerView}];
//        NSArray *constraints = [vConstraints arrayByAddingObjectsFromArray:hConstraints];
//        _horizontalOrientationConstraints = [constraints arrayByAddingObject:equalWidthConstraints];
//    }
//    return _horizontalOrientationConstraints;
//}
//
//- (NSArray *)verticalOrientationConstraints{
//    if (!_verticalOrientationConstraints) {
//        NSLayoutConstraint *equalHeightConstraints = [NSLayoutConstraint constraintWithItem:self.aContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.bContainerView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
//        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aContainerView][bContainerView]|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:@{@"aContainerView": self.aContainerView, @"bContainerView":self.bContainerView}];
//        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aContainerView]|" options:0 metrics:nil views:@{@"aContainerView":self.aContainerView}];
//        NSArray *constraints = [vConstraints arrayByAddingObjectsFromArray:hConstraints];
//        _verticalOrientationConstraints = [constraints arrayByAddingObject:equalHeightConstraints];
//    }
//    return _verticalOrientationConstraints;
//}

// Sixth changes will trigger build to automation_test branch

- (NSArray *)horizontalOrientationConstraints
{
    if (!_horizontalOrientationConstraints) {
        NSLayoutConstraint *equalWidthConstraints = [NSLayoutConstraint constraintWithItem:self.aContainerView
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.bContainerView
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                multiplier:1.0
                                                                                  constant:0];
        
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aContainerView][bContainerView]|"
                                                                        options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                        metrics:nil views:@{@"aContainerView": self.aContainerView, @"bContainerView": self.bContainerView}];
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aContainerView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"aContainerView": self.aContainerView}];
        NSArray *constraints = [vConstraints arrayByAddingObjectsFromArray:hConstraints];
        _horizontalOrientationConstraints = [constraints arrayByAddingObject:equalWidthConstraints];
        
    }
    return _horizontalOrientationConstraints;
}


- (NSArray *)verticalOrientationConstraints
{
    if (!_verticalOrientationConstraints) {
        NSLayoutConstraint *equalHeightConstraints = [NSLayoutConstraint constraintWithItem:self.aContainerView
                                                                                  attribute:NSLayoutAttributeHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.bContainerView
                                                                                  attribute:NSLayoutAttributeHeight
                                                                                 multiplier:1.0
                                                                                   constant:0];
        
        
        NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aContainerView][bContainerView]|"
                                                                        options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                        metrics:nil views:@{@"aContainerView": self.aContainerView, @"bContainerView": self.bContainerView}];
        NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aContainerView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"aContainerView": self.aContainerView}];
        NSArray *constraints = [vConstraints arrayByAddingObjectsFromArray:hConstraints];
        _verticalOrientationConstraints = [constraints arrayByAddingObject:equalHeightConstraints];
        
    }
    return _verticalOrientationConstraints;
}
@end

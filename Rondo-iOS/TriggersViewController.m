//
//  TriggersViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "TriggersViewController.h"
#import <Leanplum/Leanplum.h>
#import <LeanplumLocation/LPLocationManager.h>

@interface TriggersViewController ()

@end

@implementation TriggersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)triggerEvent:(id)sender {
    [Leanplum track:@"testEvent"];
}

- (IBAction)triggerState:(id)sender {
    [Leanplum advanceTo:@"testState"];
}

- (IBAction)changeUserAttribute:(id)sender {
    NSDictionary *attrib = @{@"age":@(arc4random())};
    [Leanplum setUserAttributes:attrib];
}

- (IBAction)trigger3xsession:(id)sender {
    [Leanplum advanceTo:@"sessionLimit"];

}

- (IBAction)trigger3xLifetime:(id)sender {
    [Leanplum advanceTo:@"lifetimeLimit"];
}

- (IBAction)chainInApp:(id)sender {
    [Leanplum track:@"chainedInApp"];
}

@end

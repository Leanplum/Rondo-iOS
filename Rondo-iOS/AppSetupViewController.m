//
//  AppSetupViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AppSetupViewController.h"
#import <Leanplum/Leanplum.h>
#import "InternalState.h"
#import "LeanplumApp.h"
#import "LeanplumEnv.h"


@interface AppSetupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *devKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prodKeyLabel;

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiSslLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketHostLabel;
@property (weak, nonatomic) IBOutlet UILabel *socketPortLabel;

@end

@implementation AppSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self populateInfo];
}

-(void)populateInfo {
    InternalState *state = [InternalState sharedState];
    LeanplumApp *app = state.app;
    LeanplumEnv *env = state.env;

    self.appNameLabel.text = app.displayName;
    self.appIdLabel.text = app.appId;
    self.devKeyLabel.text = app.devKey;
    self.prodKeyLabel.text = app.prodKey;

    self.apiHostLabel.text = env.apiHostName;
    self.apiSslLabel.text = env.apiSSL ? @"True" : @"False";
    self.socketHostLabel.text = env.socketHostName;
    self.socketPortLabel.text = [NSString stringWithFormat:@"%i", env.socketPort];
}

- (IBAction)leanplumStartPressed:(id)sender {
    [Leanplum start];
}

@end

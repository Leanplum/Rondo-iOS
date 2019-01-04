//
//  AdhocViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 12/28/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "AdhocViewController.h"
#import <Leanplum/Leanplum.h>

@interface AdhocViewController ()
@property (weak, nonatomic) IBOutlet UITextField *trackTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *userAttribTextField;

@end

@implementation AdhocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sendTrack:(id)sender {
    [Leanplum track:self.trackTextField.text];
}

- (IBAction)sendState:(id)sender {
    [Leanplum advanceTo:self.stateTextField.text];
}

- (IBAction)setUserAttrib:(id)sender {
//    [Leanplum setUserAttributes:@{}];
}

@end
//
//  VariablesViewController.m
//  Rondo-iOS
//
//  Created by Mayank Sanganeria on 10/21/18.
//  Copyright © 2018 Leanplum. All rights reserved.
//

#import "VariablesViewController.h"
#import <Leanplum/Leanplum.h>

@interface VariablesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *composerLabel;
@property (weak, nonatomic) IBOutlet UILabel *compositionLabel;

@end

DEFINE_VAR_STRING(composerName, @"defaultComposer");
DEFINE_VAR_STRING(compositionTitle, @"defaultComposition");

@implementation VariablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.composerLabel.text = composerName.stringValue;
    self.compositionLabel.text = compositionTitle.stringValue;

//    [Leanplum onVariablesChanged:^{
//        self.composerLabel.text = composerName.stringValue;
//        self.compositionLabel.text = compositionTitle.stringValue;
//    }];
//
//    [Leanplum forceContentUpdate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

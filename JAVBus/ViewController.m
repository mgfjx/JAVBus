//
//  ViewController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/13.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ViewController.h"
#import "ActressCodeController.h"
#import "AddressSettingController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBarButton {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingClicked)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)settingClicked {
    AddressSettingController *vc = [AddressSettingController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)start:(UIButton *)sender {
    ActressCodeController *vc = [ActressCodeController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

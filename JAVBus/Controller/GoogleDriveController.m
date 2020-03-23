//
//  GoogleDriveController.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/9.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "GoogleDriveController.h"
#import "GoogleSignInManager.h"
#import "GoogleDriveManager.h"
#import "GGDriveFileController.h"

@interface GoogleDriveController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UIImagePickerController* pickController;

@end

@implementation GoogleDriveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat maxY = 0;
    UIButton *tagBtn ;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 0, self.view.width - 2*20, 40);
    [button addTarget:self action:@selector(loginGoogle) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Google Login" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor randomColorWithAlpha:0.7];
    [self.view addSubview:button];
    button.y = 100;
    maxY = CGRectGetMaxY(button.frame);
    tagBtn = button;
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = tagBtn.frame;
        [button addTarget:self action:@selector(selectFile) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Select File" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor randomColorWithAlpha:0.7];
        [self.view addSubview:button];
        button.y = CGRectGetMaxY(tagBtn.frame) + 20;
        maxY = CGRectGetMaxY(button.frame);
        tagBtn = button;
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = tagBtn.frame;
        [button addTarget:self action:@selector(testDrive) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Test Drive" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor randomColorWithAlpha:0.7];
        [self.view addSubview:button];
        button.y = CGRectGetMaxY(tagBtn.frame) + 20;
        maxY = CGRectGetMaxY(button.frame);
        tagBtn = button;
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = tagBtn.frame;
        [button addTarget:self action:@selector(judgeFile) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"判斷是否存在文件夾" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor randomColorWithAlpha:0.7];
        [self.view addSubview:button];
        button.y = CGRectGetMaxY(tagBtn.frame) + 20;
        maxY = CGRectGetMaxY(button.frame);
        tagBtn = button;
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = tagBtn.frame;
        [button addTarget:self action:@selector(signInDropBox) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"SignIn DropBox" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor randomColorWithAlpha:0.7];
        [self.view addSubview:button];
        button.y = CGRectGetMaxY(tagBtn.frame) + 20;
        maxY = CGRectGetMaxY(button.frame);
        tagBtn = button;
    }
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = tagBtn.frame;
        [button addTarget:self action:@selector(getDropBoxFiles) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"DropBox Files" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor randomColorWithAlpha:0.7];
        [self.view addSubview:button];
        button.y = CGRectGetMaxY(tagBtn.frame) + 20;
        maxY = CGRectGetMaxY(button.frame);
        tagBtn = button;
    }
    
}

- (void)getDropBoxFiles {
    
    
    
}

- (void)signInDropBox {
    [[DropBoxManager shareManager] signIn];
}

- (void)judgeFile {
    
    if (![DropBoxManager shareManager].isSignIn) {
        [[DropBoxManager shareManager] signIn];
        return;
    }
    
    GGDriveFileController *vc = [GGDriveFileController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)testDrive {
    
//    [[GoogleDriveManager shareManager] getAllFileList:^(NSArray<GTLRDrive_File *> * _Nonnull fileList) {
//        for (GTLRDrive_File *file in fileList) {
//            NSLog(@"%@", file);
//        }
//    }];
    [[GoogleDriveManager shareManager] test];
    
}

- (void)loginGoogle {
    [[GoogleSignInManager shareManager] signIn];
}

- (void)uploadFile:(NSData *)fileData {
    
    [[GoogleDriveManager shareManager] uploadFile:fileData];
    
}

- (void)selectFile {
    
    //相册的资源访问UIImagePickerController来读取
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc]init];
    /*
     UIImagePickerControllerSourceTypePhotoLibrary 相册
     UIImagePickerControllerSourceTypeCamera 拍照 摄像
     UIImagePickerControllerSourceTypeSavedPhotosAlbum 时刻
     */
    //数据源类型
    imagePickerC.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    //是否允许编辑
    imagePickerC.allowsEditing = NO;
    
    imagePickerC.delegate = self;
    
    [self presentViewController:imagePickerC animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerController Delegate
//完成选择之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"info = %@",info);

    /*
     UIImagePickerControllerEditedImage:编辑后的图片
     UIImagePickerControllerOriginalImage:编辑前的图片
     */
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImagePNGRepresentation(img);
    [self uploadFile:data];
    
    
    
}

@end

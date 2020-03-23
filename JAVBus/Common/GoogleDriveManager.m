//
//  GoogleDriveManager.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/10.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "GoogleDriveManager.h"
#import "GoogleSignInManager.h"
#import <GoogleSignIn/GIDAuthentication.h>

@interface GoogleDriveManager ()

@property (nonatomic, strong) GTLRDriveService *driveService ;

@end

@implementation GoogleDriveManager

SingletonImplement(Manager);

- (GTLRDriveService *)driveService {
    if (!_driveService) {
        _driveService = [GTLRDriveService new];
        _driveService.authorizer = [GoogleSignInManager shareManager].user.authentication.fetcherAuthorizer;
    }
    return _driveService;
}

- (void)uploadFile:(NSData *)fileData {
    
    GTLRDriveService *driveService = self.driveService;
    
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = @"avbus.jpg";
    metadata.parents = @[@"1KoQVjhTF0O3MI0o1CQq3MiH5FIlhrY_A"];

    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:fileData MIMEType:@"image/jpeg"];
    uploadParameters.shouldUploadWithSingleRequest = TRUE;
    
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata uploadParameters:uploadParameters];
    query.fields = @"";
    
    query.fields = @"id,parents";
    
    [driveService executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRDrive_File *file, NSError *error) {
        if (error == nil) {
            NSLog(@"File ID %@", file.identifier);
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    
    driveService.uploadProgressBlock = ^(GTLRServiceTicket * _Nonnull progressTicket, unsigned long long totalBytesUploaded, unsigned long long totalBytesExpectedToUpload) {
        NSLog(@"進度: %f", totalBytesUploaded*1.0/totalBytesExpectedToUpload);
    };
    
}

- (void)createFolder {
    
    GTLRDriveService *driveService = self.driveService;
    
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = @"JAVBus";
    metadata.mimeType = @"application/vnd.google-apps.folder";
    
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata uploadParameters:nil];
    
    query.fields = @"id";
    [driveService executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRDrive_File *file, NSError *error) {
        if (error == nil) {
            NSLog(@"File ID %@", file.identifier);
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    
}

- (void)getAllFileList:(void (^)(NSArray<GTLRDrive_File *> *fileList))callback {
    
    GTLRDriveService *driveService = self.driveService;
    
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = @"Javbus";
    metadata.mimeType = @"application/vnd.google-apps.folder";
    
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    query.pageSize = 10;
//    query.q = @"mimeType = 'application/vnd.google-apps.folder'";
    query.q = @"'1KoQVjhTF0O3MI0o1CQq3MiH5FIlhrY_A' in parents";
    
    [driveService executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRDrive_FileList *file, NSError *error) {
        if (error == nil) {
            NSArray *fileList = file.files;
            if (callback) {
                callback(fileList);
            }
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    
}

- (void)test {
    
    [self createFolder];return;
//    [self getAllFileList:nil];return;
    
    GTLRDriveService *driveService = self.driveService;
    
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = @"Javbus";
    metadata.mimeType = @"application/vnd.google-apps.folder";
    
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    
    [driveService executeQuery:query completionHandler:^(GTLRServiceTicket *ticket, GTLRDrive_File *file, NSError *error) {
        if (error == nil) {
            NSLog(@"File ID %@", file.identifier);
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    
}

@end

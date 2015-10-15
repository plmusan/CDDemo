//
//  CDImagePicker.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDImagePicker.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

NSString *PickerTypeString(PickerType type) {
    switch (type) {
        case PickerTypeImage:
            return @"PickerTypeImage";
        case PickerTypeMovie:
            return @"PickerTypeMovie";
        default:
            return @"PickerTypeAll";
    }
}

@interface CDImagePicker ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic, strong) MediaInfo info;
@property (nonatomic) BOOL isShowImagePicker;
@property (nonatomic) NSArray *pickerTypeImage;
@property (nonatomic) NSArray *pickerTypeMovie;

@end

@implementation CDImagePicker

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self instanceImagePicker];
    }
    return self;
}

- (void)instanceImagePicker; {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.pickerTypeImage = @[@"public.image"];
    self.pickerTypeMovie = @[@"public.movie"];
}

- (void)showImagePickerWithViewController:(UIViewController *)viewController
                               sourceType:(UIImagePickerControllerSourceType)sourceType
                               pickerType:(PickerType)pickerType
                               resultInfo:(MediaInfo)info {
    self.info = info;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePicker.sourceType = sourceType;
        if (pickerType == PickerTypeImage) {
            self.imagePicker.mediaTypes = self.pickerTypeImage;
        } else if (pickerType == PickerTypeMovie) {
            self.imagePicker.mediaTypes = self.pickerTypeMovie;
        } else if (pickerType == PickerTypeAll) {
            self.imagePicker.mediaTypes  =  [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        }
        self.isShowImagePicker = YES;
        [viewController presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)dismissImagePickerAnimated:(BOOL)animated; {
    if (self.isShowImagePicker) {
        [self.imagePicker dismissViewControllerAnimated:animated completion:^{
            self.isShowImagePicker = NO;
        }];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info; {
    if (self.info) self.info(info);
    [self dismissImagePickerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    if (self.info) self.info(nil);
    [self dismissImagePickerAnimated:YES];
}

@end

@implementation CDImagePicker (Tools)

+ (UIImage *)previewImageForVideo:(NSURL *)videoURL; {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"Get video preview error: %@", error);
        return nil;
    }
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

+ (void)referenceURL:(NSURL *)url mediaName:(void (^)(NSString *name))name; {
    if (url) {
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            fileName = fileName.length == 0 ? nil : fileName;
            name(fileName);
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:url
                       resultBlock:resultblock
                      failureBlock:nil];
    } else {
        name(nil);
    }
}

@end


//
//  CDImagePicker.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

// info dictionary keys
UIKIT_EXTERN NSString *const UIImagePickerControllerMediaType;      // an NSString (UTI, i.e. kUTTypeImage)
UIKIT_EXTERN NSString *const UIImagePickerControllerOriginalImage;  // a UIImage
UIKIT_EXTERN NSString *const UIImagePickerControllerEditedImage;    // a UIImage
UIKIT_EXTERN NSString *const UIImagePickerControllerCropRect;       // an NSValue (CGRect)
UIKIT_EXTERN NSString *const UIImagePickerControllerMediaURL;       // an NSURL
UIKIT_EXTERN NSString *const UIImagePickerControllerReferenceURL;     // an NSURL that references an asset in the AssetsLibrary framework
UIKIT_EXTERN NSString *const UIImagePickerControllerMediaMetadata;   // an NSDictionary containing metadata from a captured photo

typedef void (^MediaInfo)(NSDictionary *info);

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypeImage,
    PickerTypeMovie,
    PickerTypeAll,
};
UIKIT_EXTERN NSString *PickerTypeString(PickerType type);

@interface CDImagePicker : NSObject

+ (instancetype)shareInstance;

/*!
 *  UIImagePickerController object which will show in the view
 */
@property (nonatomic, readonly) UIImagePickerController *imagePicker;
@property (nonatomic, readonly) BOOL isShowImagePicker;

/*!
 *  Displays an ImagePicker that originates from the specified view.
 *
 *  @param view       The view from which the ImagePicker originates.
 *  @param sourceType Type for UIImagePickerController
 *  @param info       media selected or canceled, the block will callback
 */
- (void)showImagePickerWithViewController:(UIViewController *)viewController
                               sourceType:(UIImagePickerControllerSourceType)sourceType
                               pickerType:(PickerType)pickerType
                               resultInfo:(MediaInfo)info  __attribute__((nonnull(1)));
- (void)dismissImagePickerAnimated:(BOOL)animated;

@end

@interface CDImagePicker (Tools)

/**
 *  Get the media's preview image with url
 *
 *  @param videoURL an NSURL for media
 *
 *  @return the media's preview image
 */
+ (UIImage *)previewImageForVideo:(NSURL *)videoURL;

/*!
 *  Get media's name with ReferenceURL
 *
 *  @param url an NSURL with the key `UIImagePickerControllerReferenceURL' from `MediaInfo' result
 *  @param name media's name, may be nil
 */
+ (void)referenceURL:(NSURL *)url mediaName:(void (^)(NSString *name))name;

@end

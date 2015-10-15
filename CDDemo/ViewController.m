//
//  ViewController.m
//  CDDemo
//
//  Created by x.wang on 15/4/29.
//  Copyright (c) 2015年 x.wang. All rights reserved.
//

#import "ViewController.h"
#import "CDTools.h"
#import "AccessLog.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *arr;

@property (nonatomic) CDBanner *banner;

@end

@implementation ViewController {
    NSUInteger index;
    CALayer *layer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.banner = [[CDBanner alloc] init];
    NSLog(@"index: %@", @(index));
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.2 alpha:1.0];
    
    UIImage *im1 = [[UIImage imageNamed:@"_or4_001.jpg"] clipCircleImageWithRadius:200];
    UIImage *im2 = [[UIImage imageNamed:@"_or5_001.jpg"] clipCircleImageWithRadius:200];
    UIImage *im3 = [[UIImage imageNamed:@"_or5_002.jpg"] clipCircleImageWithRadius:200];
    UIImage *im4 = [[UIImage imageNamed:@"_or7_003.jpg"] clipCircleImageWithRadius:200];
    UIImage *im5 = [[UIImage imageNamed:@"_or8_001.jpg"] clipCircleImageWithRadius:200];
    NSLog(@"%@\n%@\n%@\n%@\n%@", im1,im2,im3,im4,im5);
    self.arr = @[im1,im2,im3,im4,im5];
//    self.imageView.image = self.arr[index];
    layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 300, 300);
    layer.cornerRadius = 150;
    layer.contents = (id)((UIImage *)self.arr[index]).CGImage;
//    layer.borderColor = [UIColor whiteColor].CGColor;
//    layer.borderWidth = 2;
    layer.position = self.view.center;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(4, 4);
    layer.shadowOpacity = 0.5;
    [self.view.layer addSublayer:layer];
    
}

- (NSInteger)integerWithVersionString:(NSString *)versionString; {
    NSString *result = [versionString stringByReplacingOccurrencesOfString:@"." withString:@""];
    return result.integerValue;
}
- (IBAction)nextButton:(id)sender {
    index ++;
    if (index >= self.arr.count) index = 0;
    layer.contents = (id)((UIImage *)self.arr[index]).CGImage;
//    [layer setNeedsDisplay];
}
- (IBAction)backButton:(id)sender {
    index --;
    if (index >= self.arr.count) index = self.arr.count - 1;
    layer.contents = (id)((UIImage *)self.arr[index]).CGImage;
//    [layer setNeedsDisplay];
}

- (IBAction)btnv:(UIButton *)sender {
    if (sender.isLoading) {
        [sender stopLoadingAnimating];
    } else {
        [sender startLoadingAnimating];
    }
    sender.selected = sender.isLoading;
}

- (IBAction)buttonPressed:(id)sender {
    
    
    
//    NSString *ss = @"5.1.0";
//    NSInteger s = [self integerWithVersionString:ss];
//    self.imageView.image = [UIImage imageNamed:@"IMG_0067.PNG"];
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 1; i ++) {
//        LogInfo *info = [[LogInfo alloc] initWithDomainNum:1 memberNum:2 memberName:@"aaa" contentNum:3 contentTitle:@"bbb" accessDate:@"ccc"];
//        [arr addObject:info];
//    }
    
//    AccessLog *log = [[AccessLog alloc] initWithLogInfo:arr];
//    
//    NSLog(@"%@", [log JSONStringWithLogInfo]);
//    
//    
//    NSString *l = @"564.9";
//    CGFloat f = l.doubleValue;
//    
//    NSLog(@"%@", [log JSONStringWithLogInfo]);
//    [self.banner showBanner:@"Button Pressed !!!" inController:self direction:BannerDirectionTop];
//    [[CDAlert shareInstance] showAlertWithMsg:@"Button Pressed !!!" handler:^(NSUInteger buttonIndex) {
//        Toast_f(@"Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Button Pressed !!!Pressed !!!", 13);
//    }];
//    [[CDAlert shareInstance] showAlertWithMsg:@"Button Pressed !!!" handler:^(NSUInteger buttonIndex) {
//        Toast_f(@"Button Pressed !!!", 3);
//    }];
//    [[CDAlert shareInstance] showAlertWithMsg:@"Button Pressed !!!" handler:^(NSUInteger buttonIndex) {
//        Toast_f(@"Button Pressed !!!", 3);
//    }];
//    [[CDImagePicker shareInstance] showImagePickerWithViewController:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary pickerType:PickerTypeAll resultInfo:^(NSDictionary *info) {
//        NSLog(@"info %@", info);
//        [CDImagePicker referenceURL:[info objectForKey:UIImagePickerControllerReferenceURL] mediaName:^(NSString *name) {
//            NSLog(@"%@", name);
//        }];
//    }];
//    Alert([CDFileManager stringWithSize:[CDFileManager totalDiskSpace]],nil);
//    dispatch_global_async(^{
//        sleep(2);
//        dispatch_main_async_safe(^{
//            Alert([CDFileManager stringWithSize:[CDFileManager totalDiskSpace]],nil);
//        });
//    });
}

- (void)ss {
    NSString *name = @"xx";
    //    ULog(@"hello %@", name);
    Alert(@"hello %@", name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


struct SSS{
    double x;
    double y;
};

void s() {
//    struct SSS *s = malloc(sizeof(struct SSS));
////    free(s);
//    
//    struct SSS ss = {100.1,20.3};
////    ss.x;
//    s = &ss;
//    long x = (*s).x;
//    x = s -> x;
//    free(s);
}


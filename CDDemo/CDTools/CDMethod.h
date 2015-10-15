//
//  CDMethod.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDMethod : NSObject

#pragma mark -
#pragma mark ViewController
/**
 *  Get the current viewController
 */
+ (UIViewController *)currentViewController;
#pragma mark -
#pragma mark Navigation
/**
 *  Change `UINavigationController' topbar title text and tint color
 *
 *  @param navigationController Target navigation
 *  @param color Custom color
 */
+ (void)navigationController:(UINavigationController *)navigationController changeTopColor:(UIColor *)color;
#pragma mark -
#pragma mark MD5
/**
 *  Convert specify String to its md532 Bit String
 *
 *  @param string Specify String
 *
 *  @return md5 32Bit String
 */
+ (NSString *)stringWithMD532bitString:(NSString *)string;

/**
 *  Convert specify String to its md5 16Bit String
 *
 *  @param string Specify String
 *
 *  @return md5 16Bit String
 */
+ (NSString *)stringWithMD516BitString:(NSString *)string;
#pragma mark -
#pragma mark  SHA
/**
 *  Convert specify String to its SHA1 String
 *
 *  @param string Specify String
 *
 *  @return SHA1 String
 */
+ (NSString *)stringWithSHA1String:(NSString *)string;


/**
 *  Convert specify String to its SHA256 String
 *
 *  @param string Specify String
 *
 *  @return SHA256 String
 */
+ (NSString *)stringWithSHA256String:(NSString *)string;



/**
 *  Convert specify String to its SHA384 String
 *
 *  @param string Specify String
 *
 *  @return SHA384 String
 */
+ (NSString *)stringWithSHA384String:(NSString *)string;


/**
 *  Convert specify String to its SHA512 String
 *
 *  @param string Specify String
 *
 *  @return SHA512 String
 */
+ (NSString*) stringWithSHA512String:(NSString*)string;
#pragma mark -
#pragma mark AES Decrypt 128, 192, 256
/**
 *  Creates and returns a AES decrypt string object from given string use specify key and iv.
 *
 *  @param data a string that will be use to AES decrypt
 *  @param key  a key that to be used decrypt given string
 *  @param iv   a iv that to be used decrypt given string.
 *
 *  @return AES decrypt string which is be decrypt from given data
 */
+ (NSString *)aesBase64DecryptStringWith:(NSString *)data key:(NSString *)key iv:(NSString *)iv;
#pragma mark -
#pragma mark AES Encrypt 128, 192, 256
/**
 *  Creates and returns a AES encrypted data object from given string  use specify key and iv
 *
 *  @param aData a string that will be use to AES encrypted.
 *  @param key   a key that to be used encrypted given string.
 *  @param iv    a iv that to be used encrypted given string.
 *
 *  @return AES encrypted data
 */
+ (NSData *)aesEncryptDataWithString:(NSString *)aData key:(NSString *)key iv:(NSString *)iv;
#pragma mark -
#pragma mark Base64 Decode
/**
 *  Create a Base-64 encoded Data from the receiver's contents.
 *
 *  @param string be converted to Base-64 data.
 *
 *  @return A Base-64 encoded data.
 */
+ (NSData *)base64EncodedDataWithString:(NSString *)string;
#pragma mark -
#pragma mark BASE64 Encode
/**
 *  Create a Base-64 encoded NSString from the receiver's contents.
 *
 *  @param data to be converted to Base-64 string.
 *
 *  @return A Base-64 encoded string.
 */
+ (NSString *)base64EncodedStringWithData:(NSData *) data;

@end

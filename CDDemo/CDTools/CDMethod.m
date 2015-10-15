//
//  CDMethod.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "CDMethod.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation CDMethod

#pragma mark ViewController
+ (UIViewController *)currentViewController; {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark Navigation
+ (void)navigationController:(UINavigationController *)navigationController changeTopColor:(UIColor *)color; {
    if ( color ) {
        NSDictionary *attributies = [NSDictionary dictionaryWithObjectsAndKeys:
                                     color, NSForegroundColorAttributeName,
                                     nil];
        navigationController.navigationBar.titleTextAttributes = attributies;
        navigationController.navigationBar.tintColor = color;
    }
}

#pragma mark MD5
+ (NSString *)stringWithMD532bitString:(NSString *)string{
    const char *cString = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), digest);
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x",digest[i]];
    }
    return md5String;
}

+ (NSString *)stringWithMD516BitString:(NSString *)string{
    NSString *md532BitString = [self stringWithMD532bitString:string];
    NSString *md516BitString = [[md532BitString substringToIndex:24] substringFromIndex:8]; // 9~25位
    return md516BitString;
}

#pragma mark  SHA
+ (NSString *)stringWithSHA1String:(NSString *)string{
    const char *cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha1String = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i ++) {
        [sha1String appendFormat:@"%02x",digest[i]];
    }
    return sha1String;
}

+ (NSString *)stringWithSHA256String:(NSString *)string{
    const char *cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *sha256String = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i ++) {
        [sha256String appendFormat:@"%02x",digest[i]];
    }
    return sha256String;
}

+ (NSString *)stringWithSHA384String:(NSString *)string {
    const char *cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* sha384String = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [sha384String appendFormat:@"%02x", digest[i]];
    }
    
    return sha384String;
}

+ (NSString*) stringWithSHA512String:(NSString*)string {
    const char *cString = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* sha512String = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [sha512String appendFormat:@"%02x", digest[i]];
    return sha512String;
}

#pragma mark AES Decrypt 128, 192, 256
+ (NSString *)aesBase64DecryptStringWith:(NSString *)data key:(NSString *)key iv:(NSString *)iv{
    NSData *base64Data = [self base64EncodedDataWithString:data];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = [base64Data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [keyData bytes],     // Key
                                          kCCKeySizeAES128,    // kCCKeySizeAES
                                          [ivData bytes],       // IV
                                          [base64Data bytes],
                                          [base64Data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    NSString *encryptString = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytes:buffer length:encryptedSize];
        encryptString = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    }else{
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Decrypt Error!"
                                     userInfo:nil];
    }
    free(buffer);
    return encryptString;
}

#pragma mark AES Encrypt 128, 192, 256
+ (NSData *)aesEncryptDataWithString:(NSString *)aData key:(NSString *)key iv:(NSString *)iv{
    NSData *data = [aData dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    // setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [keyData bytes],     // Key
                                          kCCKeySizeAES128,    // kCCKeySizeAES
                                          [ivData bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    NSData *encryptData = nil;
    if (cryptStatus == kCCSuccess) {
        encryptData = [NSData dataWithBytes:buffer length:encryptedSize];
    }else{
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Encrypt Error!"
                                     userInfo:nil];
    }
    free(buffer); //free the buffer;
    return encryptData;
}

#pragma mark Base64 Decode
+ (NSData *)base64EncodedDataWithString:(NSString *)string{
    static const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSUInteger inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    NSMutableData *outputData = [NSMutableData dataWithLength:(inputLength / 4 + 1) * 3];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (NSUInteger index = 0; index < inputLength; index++)
    {
        unsigned char decoded = lookup[inputBytes[index] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}

#pragma mark BASE64 Encode
+ (NSString *)base64EncodedStringWithData:(NSData *) data{
    static const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [data length];
    const unsigned char *inputBytes = [data bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    unsigned char *outputBytes = (unsigned char *)malloc((unsigned long)maxOutputLength);
    
    long long index;
    long long outputLength = 0;
    for (index = 0; index < inputLength - 2; index += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[index] & 0x03) << 4) | ((inputBytes[index + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[index + 1] & 0x0F) << 2) | ((inputBytes[index + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[index + 2] & 0x3F];
    }
    
    //handle left-over data
    if (index == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[index] & 0x03) << 4) | ((inputBytes[index + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[index + 1] & 0x0F) << 2];
        outputBytes[outputLength++] = '=';
    }
    else if (index == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    NSString *base64String = nil;
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, (unsigned long)outputLength);
        base64String = [[NSString alloc] initWithBytes:outputBytes length:(unsigned long)outputLength encoding:NSASCIIStringEncoding];
    }
    free(outputBytes);
    return base64String;
}


@end

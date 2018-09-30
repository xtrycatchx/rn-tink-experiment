//
//  UglyCrypto.m
//  rn_tink_experiment
//
//  Created by Paul Sydney Orozco on 29/9/18.
//

#import <Foundation/Foundation.h>
#import "UglyCrypto.h"

@implementation UglyCrypto

RCT_EXPORT_MODULE();

/****************************************************************************
 *
 * Using AEAD
 *
 ****************************************************************************/
RCT_EXPORT_METHOD(encryptSymmetric:(NSString *)plaintext
                  contextInfo:(NSString *)contextInfo
                  key:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSError *configError = nil;
  TINKHybridConfig *config = [[TINKHybridConfig alloc] initWithError:&configError];
  if (!config || configError) {
    NSLog(@"RN-TINK Creating config - Error - %@", [configError description]);
    reject(@"encrypt", @"Error config", configError);
  }
  
  NSLog(@"RN-TINK Creating config - OK");
  
  NSError *registerError = nil;
  if (![TINKConfig registerConfig:config error:&registerError]) {
    NSLog(@"RN-TINK Register config - Error - %@", [registerError description]);
    reject(@"encrypt", @"Error registerConfig", registerError);
  }
  
  NSLog(@"RN-TINK Register config - OK");
  
  NSError *readerError = nil;
  NSData *binaryKeyset = [key dataUsingEncoding:NSUTF8StringEncoding];
  
  TINKJSONKeysetReader *reader = [[TINKJSONKeysetReader alloc] initWithSerializedKeyset:binaryKeyset
                                                                                  error:&readerError];
  if (!reader || readerError) {
    NSLog(@"RN-TINK reader - Error - %@", [readerError description]);
    reject(@"encrypt", @"Error registerConfig", readerError);
  }
  
  NSError *handleError = nil;
  TINKKeysetHandle *handle = [[TINKKeysetHandle alloc] initCleartextKeysetHandleWithKeysetReader:reader
                                                                                           error:&handleError];
  if(!handle || handleError) {
    NSLog(@"RN-TINK Handle - Error - %@", [handleError description]);
    reject(@"encrypt", @"Error handle", handleError);
  }

  

// WORKING CODES, KEYS generated INTERNALLY
//  NSError *tplError = nil;
//  TINKAeadKeyTemplate *tpl = [[TINKAeadKeyTemplate alloc] initWithKeyTemplate:TINKAes128Gcm error:&tplError];
//  if (!tpl || tplError) {
//    NSLog(@"RN-TINK Template TINKAes128Gcm - Error - %@", [tplError description]);
//    reject(@"encrypt", @"Error template", tplError);
//  }
//
//  NSLog(@"RN-TINK Template TINKEciesP256HkdfHmacSha256Aes128Gcm - OK");
//
//  NSError *handleError = nil;
//  TINKKeysetHandle *handle = [[TINKKeysetHandle alloc] initWithKeyTemplate:tpl error:&handleError];
//  if (!handle || handleError) {
//    NSLog(@"RN-TINK Handle - Error - %@", [handleError description]);
//    reject(@"encrypt", @"Error handle", handleError);
//  }
  
  NSLog(@"RN-TINK Handle - OK");
  
  // 2. Get the primitive.
  NSError *primitiveError = nil;
  id<TINKAead> aead = [TINKAeadFactory primitiveWithKeysetHandle:handle error:&primitiveError];
  if (!aead || primitiveError) {
    NSLog(@"RN-TINK Primitive - Error - %@", [primitiveError description]);
    reject(@"encrypt", @"Error primitive", primitiveError);
  }
  
  NSLog(@"RN-TINK Primitive - OK");
  
  // 3. Use the primitive.
  NSData* plaintextData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
  NSData* aad = [contextInfo dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *encryptError = nil;
  // 3. Use the primitive.
  NSData *ciphertext = [aead encrypt:plaintextData withAdditionalData:aad error:&encryptError];
  if (!ciphertext || encryptError) {
    NSLog(@"RN-TINK Encrypt - Error - %@", [encryptError description]);
    reject(@"encrypt", @"Error encrypting", encryptError);
  }
  
  NSLog(@"RN-TINK Encrypted SYMMETRIC - OK : %@", ciphertext);
  
  NSString* base64String = [ciphertext base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
  resolve(base64String);
}


/****************************************************************************
 *
 * Using Hybrid
 *
 ****************************************************************************/
RCT_EXPORT_METHOD(encryptAsymmetric:(NSString *)plaintext
                  contextInfo:(NSString *)contextInfo
                  key:(NSString *)key
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSError *configError = nil;
  TINKHybridConfig *config = [[TINKHybridConfig alloc] initWithError:&configError];
  if (!config || configError) {
    NSLog(@"RN-TINK Creating config - Error - %@", [configError description]);
    reject(@"encrypt", @"Error config", configError);
  }
  
  NSLog(@"RN-TINK Creating config - OK");
  
  NSError *registerError = nil;
  if (![TINKConfig registerConfig:config error:&registerError]) {
    NSLog(@"RN-TINK Register config - Error - %@", [registerError description]);
    reject(@"encrypt", @"Error registerConfig", registerError);
  }
  
  NSLog(@"RN-TINK Register config - OK");
  
  NSError *readerError = nil;
  NSData *binaryKeyset = [key dataUsingEncoding:NSUTF8StringEncoding];
  
  TINKJSONKeysetReader *reader = [[TINKJSONKeysetReader alloc] initWithSerializedKeyset:binaryKeyset
                                                                                  error:&readerError];
  if (!reader || readerError) {
    NSLog(@"RN-TINK reader - Error - %@", [readerError description]);
    reject(@"encrypt", @"Error registerConfig", readerError);
  }
  
  NSError *handleError = nil;
  TINKKeysetHandle *handle = [[TINKKeysetHandle alloc] initCleartextKeysetHandleWithKeysetReader:reader
                                                                                           error:&handleError];
  if(!handle || handleError) {
    NSLog(@"RN-TINK Handle - Error - %@", [handleError description]);
    reject(@"encrypt", @"Error handle", handleError);
  }
  
  NSLog(@"RN-TINK Handle - OK");
  
  NSError *primitiveError = nil;
  id<TINKHybridEncrypt> hybridEncrypt = [TINKHybridEncryptFactory primitiveWithKeysetHandle:handle
                                                                             error:&primitiveError];
  if (!hybridEncrypt || primitiveError) {
    NSLog(@"RN-TINK Primitive - Error - %@", [primitiveError description]);
    reject(@"encrypt", @"Error primitive", primitiveError);
  }
  
  NSLog(@"RN-TINK Primitive - OK");
  
  NSData* plaintextData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
  NSData* withContextInfoData = [contextInfo dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *encryptError = nil;
  NSData *encrypted = [hybridEncrypt encrypt:plaintextData withContextInfo:withContextInfoData error:&encryptError];
  if (!encrypted || encryptError) {
    NSLog(@"RN-TINK Encrypt - Error - %@", [encryptError description]);
    reject(@"encrypt", @"Error encrypting", encryptError);
  }
  
  NSLog(@"RN-TINK Encrypted ASYMMETRIC - OK : %@", encrypted);
  NSString* base64String = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
  resolve(base64String);
}


@end

//
//  SuperEncrypt.m
//  SuperPlayer
//
//  Created by annidyfeng on 2019/3/21.
//

#import "SuperEncrypt.h"

// https://gist.github.com/aleclaws/e1eb680081f05dfa6bb5b70d89bbd69c

void queryValueToData(NSMutableDictionary *query, void * value) {
    query[(__bridge id)kSecValueRef] = (__bridge id)value ;
    query[(__bridge id)kSecReturnData] = @YES ;
}

void queryDataToValue(NSMutableDictionary *query, id data) {
    query[(__bridge id)kSecValueData] = data ;
    query[(__bridge id)kSecReturnRef] = @YES ;
}



NSMutableDictionary * rsa2048KeyQuery(NSData* tag) {
    NSMutableDictionary * rsaQuery = [[NSMutableDictionary alloc] init];
    
    rsaQuery[(__bridge id)kSecClass]              = (__bridge id)kSecClassKey;
    rsaQuery[(__bridge id)kSecAttrKeyType]        = (__bridge id)kSecAttrKeyTypeRSA ;
    rsaQuery[(__bridge id)kSecAttrApplicationTag] = tag ;
    rsaQuery[(__bridge id)kSecAttrKeySizeInBits]  = @(2048);
    
    return rsaQuery;
}


OSStatus queryAddAndRemove(NSMutableDictionary * query, CFTypeRef * ref) {
    OSStatus sanityCheck;
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) query, ref);
    
    if(sanityCheck == errSecDuplicateItem) {
        // if it was already there, need to delete before we add
        (void) SecItemDelete((__bridge CFDictionaryRef) query);
        sanityCheck = SecItemAdd((__bridge CFDictionaryRef) query, ref);
    }
    
    // delete from Keychain
    (void) SecItemDelete((__bridge CFDictionaryRef) query);
    
    return sanityCheck;
}

// CONVERT BETWEEN SECKEYREF AND NSDATA

#define kMyKeyTag "com.apple.app.mykey"
static const uint8_t kMyKeyIdentifier[] = kMyKeyTag;

NSData * dataFromKey(SecKeyRef givenKey) {
    
    
    // http://stackoverflow.com/questions/16748993/ios-seckeyref-to-nsdata
    NSData *publicTag = [[NSData alloc] initWithBytes:kMyKeyIdentifier
                                               length:sizeof(kMyKeyIdentifier)];
    
    // BUILD query
    NSMutableDictionary * queryPublicKey = rsa2048KeyQuery(publicTag);
    queryValueToData(queryPublicKey, givenKey);
    
    // MAKE query
    CFDataRef result;
    OSStatus sanityCheck = noErr;
    sanityCheck = queryAddAndRemove(queryPublicKey, (CFTypeRef *)&result);
    
    // SETUP result
    NSData * publicKeyBits = nil;
    if (sanityCheck == errSecSuccess) {
        publicKeyBits = CFBridgingRelease(result);
    }
    
    return publicKeyBits;
}



SecKeyRef keyFromData(NSData* data, CFTypeRef keyclass) {
    
    
    NSData *tag = [[NSData alloc] initWithBytes:kMyKeyIdentifier
                                         length:sizeof kMyKeyIdentifier];
    
    // BUILD query
    NSMutableDictionary * queryPublicKey = rsa2048KeyQuery(tag);
    queryPublicKey[(__bridge id)kSecAttrKeyClass] = (__bridge id)keyclass ;
    queryDataToValue(queryPublicKey, data);
    
    // MAKE query
    SecKeyRef keyRef = nil;
    (void) queryAddAndRemove(queryPublicKey, (CFTypeRef *)&keyRef);
    
    return keyRef;
}



@implementation SuperEncrypt {
    SecKeyRef _privateKey;
    SecKeyRef _publicKey;
}

- (id)init
{
    self = [super init];
    
    NSDictionary* attributes = [SuperEncrypt getAttributes:@kMyKeyTag];
    OSStatus status = SecKeyGeneratePair( (__bridge CFDictionaryRef)attributes, &_publicKey, &_privateKey);
    if (status != errSecSuccess) {
        return nil;
    }
    
    return self;
}

+(NSDictionary*)getAttributes:(NSString*)secretCode  {
    
    NSData* tag = [secretCode dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:      (id)kSecAttrKeyTypeRSA,
       (id)kSecAttrKeySizeInBits:    @2048,
       (id)kSecPrivateKeyAttrs:
           @{ (id)kSecAttrIsPermanent:    @YES,
              (id)kSecAttrApplicationTag: tag,
              },
       };
    
    return attributes;
}

- (NSString *)getPublicKey
{
    return [dataFromKey(_publicKey) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
}


- (NSString*) encrypt:(NSString *)string  {
    
    
    if (@available(iOS 10.0, *)) {
        SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSAEncryptionOAEPSHA512;
        BOOL canEncrypt = SecKeyIsAlgorithmSupported(_publicKey,
                                                     kSecKeyOperationTypeEncrypt,
                                                     algorithm);
        
        NSData *plainText = [string dataUsingEncoding:NSUTF8StringEncoding];
        canEncrypt &= ([plainText length] < (SecKeyGetBlockSize(_publicKey)-130));
        
        NSData* encryptedData = nil;
        if (canEncrypt) {
            CFErrorRef error = NULL;
            encryptedData = (NSData*)CFBridgingRelease(SecKeyCreateEncryptedData(_publicKey,
                                                                                 algorithm,
                                                                                 (__bridge CFDataRef)plainText,
                                                                                 &error));
            if (!encryptedData) {
                NSError *err = CFBridgingRelease(error);
                NSLog(@"%@", err);
                return nil;
            }
        }
        
        
        NSString* finalEncryptedString = [encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];//[encryptedData ];
        
        return finalEncryptedString;
    }
    return nil;
}

- (NSString*) decrypt:(NSString*)encryptedString {
    
    NSData* cipherTextData = [[NSData alloc] initWithBase64EncodedString:encryptedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    
    if (@available(iOS 10.0, *)) {
    
        SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSAEncryptionOAEPSHA512;
        
        BOOL canDecrypt = SecKeyIsAlgorithmSupported(_privateKey,
                                                     kSecKeyOperationTypeDecrypt,
                                                     algorithm);
        canDecrypt &= ([cipherTextData length] == SecKeyGetBlockSize(_privateKey));
        
        NSData* clearText = nil;
        if (canDecrypt) {
            CFErrorRef error = NULL;
            clearText = (NSData*)CFBridgingRelease(SecKeyCreateDecryptedData(_privateKey,
                                                                             algorithm,
                                                                             (__bridge CFDataRef)cipherTextData,
                                                                             &error));
            if (!clearText) {
                NSError *err = CFBridgingRelease(error);  // ARC takes ownership
                NSLog(@"Cannot decrypt:  %@",err);
                return nil;
            } else {
                NSLog(@"SUCCESS decrypt");
                NSString* finalStr = [[NSString alloc] initWithData:clearText encoding:NSUTF8StringEncoding];
                NSLog(@"Str: %@",finalStr);
                return finalStr;
            }
        } else {
            NSLog(@"Cannot decrypt");
            return nil;
        }
    }
    return nil;
}

@end

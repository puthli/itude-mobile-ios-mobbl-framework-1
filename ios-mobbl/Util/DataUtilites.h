//
//  DataUtilites.h
//  Core
//
//  Created by Robert Meijer on 5/26/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

@interface NSData (BundleAdditions)

+ (NSData*)dataWithContentsOfMainBundle:(NSString*)path;
+ (NSData*) dataWithEncodedContentsOfMainBundle:(NSString*)path;
+ (NSString*) determineFileName:(NSString*) name;
+ (BOOL) encryptionNeeded:(NSString*)absPath;

@end

@interface NSData (NSDataExtension)

// Returns range [start, null byte), or (NSNotFound, 0).
- (NSRange) rangeOfNullTerminatedBytesFrom:(int)start;

// Canonical Base32 encoding/decoding.
+ (NSData *) dataWithBase32String:(NSString *)base32;
- (NSString *) base32String;

// COBS is an encoding that eliminates 0x00.
- (NSData *) encodeCOBS;
- (NSData *) decodeCOBS;

// ZLIB
- (NSData *) zlibInflate;
- (NSData *) zlibDeflate;

// GZIP
- (NSData *) gzipInflate;
- (NSData *) gzipDeflate;

//CRC32
- (unsigned int)crc32;

@end

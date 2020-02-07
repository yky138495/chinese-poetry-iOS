//
//  CFileHandle.h
//
//  Created by sun on 10-11-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned long long TFileSize;

@interface CFileHandle : NSObject
{
	NSFileHandle* _fileHandle;
}
+ (id) fileHandleForReadAtPath:(NSString*)path;
+ (id) fileHandleForWriteAtPath:(NSString*)path;
+ (BOOL) createDirectoryAtPath:(NSString *)path;
+ (BOOL) removeFileAtPath:(NSString*)path;
+ (BOOL) containFileAtPath:(NSString*)path;
+ (BOOL) moveItemAtPath:(NSString *)srcPath toPath:(NSString *)toPath;
//Add By yangmengge
+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)toPath;
+ (TFileSize) getFileSize:(NSString*)path;
+ (void) removeFilesAtDirPath:(NSString*)path ext:(NSString*)ext;
+ (NSArray*) getContentsbyDir:(NSString*)path;
+ (NSDate*) getFileModificationDate:(NSString*)path;
+ (BOOL) isDirectory:(NSString*)path;
+ (BOOL) writeData:(NSData*)data toPath:(NSString*)path;
+ (NSData*) readDataFromPath:(NSString*)path;
- (void) appendData:(NSData*)data;
- (void) writeData:(NSData*)data;
- (NSData*) readData;
@end

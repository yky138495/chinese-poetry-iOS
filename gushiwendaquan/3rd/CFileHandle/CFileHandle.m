//
//  CFileHandle.m
//
//  Created by sun on 10-11-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CFileHandle.h"

@interface CFileHandle (Private)

- (id) initWithNSFileHandle:(NSFileHandle*)fileHandle;

@end


@implementation CFileHandle

+ (id) fileHandleForReadAtPath:(NSString*)path
{
	if (path == nil) return nil;
	NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	if (fileHandle == nil) return nil;
	
	return [[CFileHandle alloc] initWithNSFileHandle:fileHandle];
}

+ (id) fileHandleForWriteAtPath:(NSString*)path
{
	if (path == nil) return nil;
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	if (![tFileManager fileExistsAtPath:path])
	{
		[tFileManager createFileAtPath:path contents:nil attributes:nil];
	}
	
	NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	if (fileHandle == nil) return nil;
	
	return [[CFileHandle alloc] initWithNSFileHandle:fileHandle];
}

- (id) initWithNSFileHandle:(NSFileHandle*)fileHandle;
{
    if ((self = [super init])) 
	{
		_fileHandle = fileHandle;
    }
    return self;
}

- (void) appendData:(NSData*)data
{
	NSAssert(data != nil, @"data不可以为nil");
	[_fileHandle seekToEndOfFile];
	NSUInteger dataLen = [data length];
	NSData* tData = [NSData dataWithBytes:&dataLen length:4];
	[_fileHandle writeData:tData];
	[_fileHandle writeData:data];
	[_fileHandle synchronizeFile];
}

- (void) writeData:(NSData*)data
{
	NSAssert(data != nil, @"data不可以为nil");
	NSUInteger dataLen = [data length];
	NSData* tData = [NSData dataWithBytes:&dataLen length:4];
	[_fileHandle writeData:tData];
	[_fileHandle writeData:data];
	[_fileHandle synchronizeFile];
}

- (NSData*) readData
{
	NSData* data = [_fileHandle readDataOfLength:4];
	if (data == nil) return nil;
	
	int dataLen = 0;
	[data getBytes:&dataLen length:4];
	
	if (dataLen <= 0) return nil;
	
	return [_fileHandle readDataOfLength:dataLen];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path
{
    if ([self isDirectory:path]) {
        return YES;
    }
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    return (error == nil);
}

+ (BOOL) removeFileAtPath:(NSString*)path
{
	if (path == nil) return YES;
	
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	if ([tFileManager fileExistsAtPath:path])
	{
		NSError *errorInfo;
		[tFileManager removeItemAtPath:path error:&errorInfo];
	}
	
	return YES;
}

+ (BOOL) containFileAtPath:(NSString*)path
{
	if (path == nil) return NO;	
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)toPath
{
    if (srcPath == nil || toPath == nil)
        return NO;
    if (![self containFileAtPath:srcPath])
        return NO;
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:toPath error:&error];
    return (error == nil);
}

+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)toPath
{
    if (srcPath == nil || toPath == nil)
        return NO;
    if (![self containFileAtPath:srcPath])
        return NO;
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:toPath error:&error];
    return (error == nil);
}

+ (TFileSize) getFileSize:(NSString*)path
{
	if (path == nil) return 0;
	
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	NSError *errorInfo = nil;
	NSDictionary* attributes = [tFileManager attributesOfItemAtPath:path error:&errorInfo];
	
	TFileSize fileLength = 0;
	if (attributes != nil)
	{
		fileLength = [attributes fileSize];
	}
	return fileLength;
}

+ (void) removeFilesAtDirPath:(NSString*)path ext:(NSString*)ext
{
	if (path == nil) return;
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	NSError *errorInfo = nil;
	
	NSArray* files = [tFileManager contentsOfDirectoryAtPath:path error:&errorInfo];
	if (errorInfo == nil)
	{
		for (NSString* filePath in files)
		{
			if ([filePath hasSuffix:ext])
			{
				[tFileManager removeItemAtPath:filePath error:&errorInfo];
			}
		}
	}
}

+ (NSArray*) getContentsbyDir:(NSString*)path
{
	if (path == nil) return nil;
	
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	NSError *errorInfo = nil;
	return [tFileManager contentsOfDirectoryAtPath:path error:&errorInfo];
}

+ (NSDate*) getFileModificationDate:(NSString*)path
{
	if (path == nil) return nil;
	
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	NSError *errorInfo = nil;
	NSDictionary* attributes = [tFileManager attributesOfItemAtPath:path error:&errorInfo];
	
	NSDate* date = nil;;
	if (attributes != nil)
	{
		date = [attributes fileModificationDate];
	}
	return date;
}

+ (BOOL) isDirectory:(NSString*)path
{
	if (path == nil) return NO;
	
	NSFileManager* tFileManager = [NSFileManager defaultManager];
	NSError *errorInfo = nil;
	NSDictionary* attributes = [tFileManager attributesOfItemAtPath:path error:&errorInfo];
	
	NSString *fileType = nil;
	if (attributes != nil)
	{
		fileType = [attributes fileType];
	}
	
	BOOL isDirectory = NO;
	if ([fileType isEqualToString:NSFileTypeDirectory]) 
	{
		isDirectory = YES;
	}
	else
	{
		isDirectory = NO;
	}
	
	return isDirectory;
}

+ (BOOL) writeData:(NSData*)data toPath:(NSString*)path
{
	if (path == nil) return NO;
	
	CFileHandle* tFileHandle = [CFileHandle fileHandleForWriteAtPath:path];
	if (tFileHandle == nil) return NO;

	[tFileHandle writeData:data];
	return YES;
}

+ (NSData*) readDataFromPath:(NSString*)path
{
	NSData* data = nil;
	if (path != nil)
	{
		CFileHandle* tFileHandle = [CFileHandle fileHandleForReadAtPath:path];
		if (tFileHandle != nil)
		{
			data = [tFileHandle readData];
		}
	}
	return data;
}

@end

//
//  ShakeFile.h
//  Shake
//
//  Created by Ante Baus on 19/11/2018.
//  Copyright © 2018 Shake Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(ShakeFile)
@interface SHKShakeFile : NSObject <NSCoding, NSSecureCoding>

/**
 Name of the file to upload.
 */
@property (nonatomic, strong, nonnull) NSString *name;

/**
 Contents (NSData) of the file to upload
 */
@property (nonatomic, strong, nonnull) NSData *data;

/**
 Initializes the ShakeFile object with name and data to upload.
 Both values are required to be non-null.
 
 @param name Name of the file to be uploaded.
 @param data Data of the file to be uploaded.
 @return Instance of the ShakeFile class
 */
- (nonnull instancetype)initWithName:(nonnull NSString *)name andData:(nonnull NSData *)data
NS_SWIFT_NAME(init(name:data:));

/**
 Initializes the ShakeFile object with name and file url to load into the data.
 Can return nil if data can not be loaded from the URL.

 @param name Name of the file to be uploaded.
 @param url URL of the data to be loaded.
 @return Instance of ShakeFile object or null if the data can not be loaded from the passed url.
 */
- (nullable instancetype)initWithName:(nonnull NSString *)name andFileURL:(nonnull NSURL *)url
NS_SWIFT_NAME(init(name:fileUrl:));

/**
 Initializes the ShakeFile object with file url to load into the data, file name is set automatically using file url.
 Can return nil if data can not be loaded from the URL.

 @param url URL of the data to be loaded.
 @return Instance of ShakeFile object or null if the data can not be loaded from the passed url.
 */
- (nullable instancetype)initWithFileURL:(nonnull NSURL *)url
NS_SWIFT_NAME(init(fileUrl:));

@end

@interface SHKShakeFile (Equatable)

- (BOOL)fileIsEqual:(SHKShakeFile*)file;

@end

NS_ASSUME_NONNULL_END

///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGListFileMembersContinueArg;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `ListFileMembersContinueArg` struct.
///
/// Arguments for `listFileMembersContinue`.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGListFileMembersContinueArg : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The cursor returned by your last call to `listFileMembers`,
/// `listFileMembersContinue`, or `listFileMembersBatch`.
@property (nonatomic, readonly, copy) NSString *cursor;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param cursor The cursor returned by your last call to `listFileMembers`,
/// `listFileMembersContinue`, or `listFileMembersBatch`.
///
/// @return An initialized instance.
///
- (instancetype)initWithCursor:(NSString *)cursor;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `ListFileMembersContinueArg` struct.
///
@interface DBSHARINGListFileMembersContinueArgSerializer : NSObject

///
/// Serializes `DBSHARINGListFileMembersContinueArg` instances.
///
/// @param instance An instance of the `DBSHARINGListFileMembersContinueArg` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGListFileMembersContinueArg` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBSHARINGListFileMembersContinueArg *)instance;

///
/// Deserializes `DBSHARINGListFileMembersContinueArg` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGListFileMembersContinueArg` API object.
///
/// @return An instantiation of the `DBSHARINGListFileMembersContinueArg`
/// object.
///
+ (DBSHARINGListFileMembersContinueArg *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END

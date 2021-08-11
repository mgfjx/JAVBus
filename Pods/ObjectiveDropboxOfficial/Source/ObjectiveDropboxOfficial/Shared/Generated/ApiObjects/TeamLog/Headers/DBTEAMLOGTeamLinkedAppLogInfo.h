///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"
#import "DBTEAMLOGAppLogInfo.h"

@class DBTEAMLOGTeamLinkedAppLogInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamLinkedAppLogInfo` struct.
///
/// Team linked app
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGTeamLinkedAppLogInfo : DBTEAMLOGAppLogInfo <DBSerializable, NSCopying>

#pragma mark - Instance fields

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param appId App unique ID. Might be missing due to historical data gap.
/// @param displayName App display name. Might be missing due to historical data
/// gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithAppId:(nullable NSString *)appId displayName:(nullable NSString *)displayName;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TeamLinkedAppLogInfo` struct.
///
@interface DBTEAMLOGTeamLinkedAppLogInfoSerializer : NSObject

///
/// Serializes `DBTEAMLOGTeamLinkedAppLogInfo` instances.
///
/// @param instance An instance of the `DBTEAMLOGTeamLinkedAppLogInfo` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGTeamLinkedAppLogInfo` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGTeamLinkedAppLogInfo *)instance;

///
/// Deserializes `DBTEAMLOGTeamLinkedAppLogInfo` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGTeamLinkedAppLogInfo` API object.
///
/// @return An instantiation of the `DBTEAMLOGTeamLinkedAppLogInfo` object.
///
+ (DBTEAMLOGTeamLinkedAppLogInfo *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END

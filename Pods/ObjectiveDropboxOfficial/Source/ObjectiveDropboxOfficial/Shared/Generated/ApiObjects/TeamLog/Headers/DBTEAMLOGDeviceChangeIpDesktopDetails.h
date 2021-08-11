///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGDeviceChangeIpDesktopDetails;
@class DBTEAMLOGDeviceSessionLogInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `DeviceChangeIpDesktopDetails` struct.
///
/// Changed IP address associated with active desktop session.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGDeviceChangeIpDesktopDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Device's session logged information.
@property (nonatomic, readonly) DBTEAMLOGDeviceSessionLogInfo *deviceSessionInfo;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param deviceSessionInfo Device's session logged information.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceSessionInfo:(DBTEAMLOGDeviceSessionLogInfo *)deviceSessionInfo;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DeviceChangeIpDesktopDetails` struct.
///
@interface DBTEAMLOGDeviceChangeIpDesktopDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGDeviceChangeIpDesktopDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGDeviceChangeIpDesktopDetails`
/// API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceChangeIpDesktopDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGDeviceChangeIpDesktopDetails *)instance;

///
/// Deserializes `DBTEAMLOGDeviceChangeIpDesktopDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceChangeIpDesktopDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGDeviceChangeIpDesktopDetails`
/// object.
///
+ (DBTEAMLOGDeviceChangeIpDesktopDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END

///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGLinkAccessLevel;
@class DBSHARINGLinkAudience;
@class DBSHARINGLinkPermissions;
@class DBSHARINGRequestedVisibility;
@class DBSHARINGResolvedVisibility;
@class DBSHARINGSharedLinkAccessFailureReason;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `LinkPermissions` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGLinkPermissions : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The current visibility of the link after considering the shared links
/// policies of the the team (in case the link's owner is part of a team) and
/// the shared folder (in case the linked file is part of a shared folder). This
/// field is shown only if the caller has access to this info (the link's owner
/// always has access to this data). For some links, an effective_audience value
/// is returned instead.
@property (nonatomic, readonly, nullable) DBSHARINGResolvedVisibility *resolvedVisibility;

/// The shared link's requested visibility. This can be overridden by the team
/// and shared folder policies. The final visibility, after considering these
/// policies, can be found in resolvedVisibility. This is shown only if the
/// caller is the link's owner and resolved_visibility is returned instead of
/// effective_audience.
@property (nonatomic, readonly, nullable) DBSHARINGRequestedVisibility *requestedVisibility;

/// Whether the caller can revoke the shared link.
@property (nonatomic, readonly) NSNumber *canRevoke;

/// The failure reason for revoking the link. This field will only be present if
/// the canRevoke is false.
@property (nonatomic, readonly, nullable) DBSHARINGSharedLinkAccessFailureReason *revokeFailureReason;

/// The type of audience who can benefit from the access level specified by the
/// `link_access_level` field.
@property (nonatomic, readonly, nullable) DBSHARINGLinkAudience *effectiveAudience;

/// The access level that the link will grant to its users. A link can grant
/// additional rights to a user beyond their current access level. For example,
/// if a user was invited as a viewer to a file, and then opens a link with
/// `link_access_level` set to `editor`, then they will gain editor privileges.
/// The `link_access_level` is a property of the link, and does not depend on
/// who is calling this API. In particular, `link_access_level` does not take
/// into account the API caller's current permissions to the content.
@property (nonatomic, readonly, nullable) DBSHARINGLinkAccessLevel *linkAccessLevel;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param canRevoke Whether the caller can revoke the shared link.
/// @param resolvedVisibility The current visibility of the link after
/// considering the shared links policies of the the team (in case the link's
/// owner is part of a team) and the shared folder (in case the linked file is
/// part of a shared folder). This field is shown only if the caller has access
/// to this info (the link's owner always has access to this data). For some
/// links, an effective_audience value is returned instead.
/// @param requestedVisibility The shared link's requested visibility. This can
/// be overridden by the team and shared folder policies. The final visibility,
/// after considering these policies, can be found in resolvedVisibility. This
/// is shown only if the caller is the link's owner and resolved_visibility is
/// returned instead of effective_audience.
/// @param revokeFailureReason The failure reason for revoking the link. This
/// field will only be present if the canRevoke is false.
/// @param effectiveAudience The type of audience who can benefit from the
/// access level specified by the `link_access_level` field.
/// @param linkAccessLevel The access level that the link will grant to its
/// users. A link can grant additional rights to a user beyond their current
/// access level. For example, if a user was invited as a viewer to a file, and
/// then opens a link with `link_access_level` set to `editor`, then they will
/// gain editor privileges. The `link_access_level` is a property of the link,
/// and does not depend on who is calling this API. In particular,
/// `link_access_level` does not take into account the API caller's current
/// permissions to the content.
///
/// @return An initialized instance.
///
- (instancetype)initWithCanRevoke:(NSNumber *)canRevoke
               resolvedVisibility:(nullable DBSHARINGResolvedVisibility *)resolvedVisibility
              requestedVisibility:(nullable DBSHARINGRequestedVisibility *)requestedVisibility
              revokeFailureReason:(nullable DBSHARINGSharedLinkAccessFailureReason *)revokeFailureReason
                effectiveAudience:(nullable DBSHARINGLinkAudience *)effectiveAudience
                  linkAccessLevel:(nullable DBSHARINGLinkAccessLevel *)linkAccessLevel;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param canRevoke Whether the caller can revoke the shared link.
///
/// @return An initialized instance.
///
- (instancetype)initWithCanRevoke:(NSNumber *)canRevoke;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `LinkPermissions` struct.
///
@interface DBSHARINGLinkPermissionsSerializer : NSObject

///
/// Serializes `DBSHARINGLinkPermissions` instances.
///
/// @param instance An instance of the `DBSHARINGLinkPermissions` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGLinkPermissions` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBSHARINGLinkPermissions *)instance;

///
/// Deserializes `DBSHARINGLinkPermissions` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGLinkPermissions` API object.
///
/// @return An instantiation of the `DBSHARINGLinkPermissions` object.
///
+ (DBSHARINGLinkPermissions *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGLinkAudience;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `LinkAudience` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGLinkAudience : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBSHARINGLinkAudienceTag` enum type represents the possible tag states
/// with which the `DBSHARINGLinkAudience` union can exist.
typedef NS_ENUM(NSInteger, DBSHARINGLinkAudienceTag) {
  /// Link is accessible by anyone.
  DBSHARINGLinkAudiencePublic,

  /// Link is accessible only by team members.
  DBSHARINGLinkAudienceTeam,

  /// The link can be used by no one. The link merely points the user to the
  /// content, and does not grant additional rights to the user. Members of
  /// the content who use this link can only access the content with their
  /// pre-existing access rights.
  DBSHARINGLinkAudienceNoOne,

  /// A link-specific password is required to access the link. Login is not
  /// required.
  DBSHARINGLinkAudiencePassword,

  /// Link is accessible only by members of the content.
  DBSHARINGLinkAudienceMembers,

  /// (no description).
  DBSHARINGLinkAudienceOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBSHARINGLinkAudienceTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "public".
///
/// Description of the "public" tag state: Link is accessible by anyone.
///
/// @return An initialized instance.
///
- (instancetype)initWithPublic;

///
/// Initializes union class with tag state of "team".
///
/// Description of the "team" tag state: Link is accessible only by team
/// members.
///
/// @return An initialized instance.
///
- (instancetype)initWithTeam;

///
/// Initializes union class with tag state of "no_one".
///
/// Description of the "no_one" tag state: The link can be used by no one. The
/// link merely points the user to the content, and does not grant additional
/// rights to the user. Members of the content who use this link can only access
/// the content with their pre-existing access rights.
///
/// @return An initialized instance.
///
- (instancetype)initWithNoOne;

///
/// Initializes union class with tag state of "password".
///
/// Description of the "password" tag state: A link-specific password is
/// required to access the link. Login is not required.
///
/// @return An initialized instance.
///
- (instancetype)initWithPassword;

///
/// Initializes union class with tag state of "members".
///
/// Description of the "members" tag state: Link is accessible only by members
/// of the content.
///
/// @return An initialized instance.
///
- (instancetype)initWithMembers;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "public".
///
/// @return Whether the union's current tag state has value "public".
///
- (BOOL)isPublic;

///
/// Retrieves whether the union's current tag state has value "team".
///
/// @return Whether the union's current tag state has value "team".
///
- (BOOL)isTeam;

///
/// Retrieves whether the union's current tag state has value "no_one".
///
/// @return Whether the union's current tag state has value "no_one".
///
- (BOOL)isNoOne;

///
/// Retrieves whether the union's current tag state has value "password".
///
/// @return Whether the union's current tag state has value "password".
///
- (BOOL)isPassword;

///
/// Retrieves whether the union's current tag state has value "members".
///
/// @return Whether the union's current tag state has value "members".
///
- (BOOL)isMembers;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBSHARINGLinkAudience` union.
///
@interface DBSHARINGLinkAudienceSerializer : NSObject

///
/// Serializes `DBSHARINGLinkAudience` instances.
///
/// @param instance An instance of the `DBSHARINGLinkAudience` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGLinkAudience` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBSHARINGLinkAudience *)instance;

///
/// Deserializes `DBSHARINGLinkAudience` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGLinkAudience` API object.
///
/// @return An instantiation of the `DBSHARINGLinkAudience` object.
///
+ (DBSHARINGLinkAudience *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END

#if 0
#elif defined(__arm64__) && __arm64__
// Generated by Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
#ifndef FLYSHOTSDK_SWIFT_H
#define FLYSHOTSDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="FlyshotSDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

typedef SWIFT_ENUM(NSInteger, CampaignStatus, open) {
  CampaignStatusNotFound = 0,
  CampaignStatusFound = 1,
  CampaignStatusRedeemed = 2,
  CampaignStatusCanceled = 3,
};

@class TestManager;
@protocol FlyshotDelegate;
@class PromoCampaign;
@class Post;

/// Class providing Sdk functionality
SWIFT_CLASS("_TtC10FlyshotSDK7Flyshot")
@interface Flyshot : NSObject
/// Gets the singleton instance of a Flyshot.
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) Flyshot * _Nonnull shared;)
+ (Flyshot * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
/// Gets the singleton instance of a TestManager
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) TestManager * _Nonnull test;)
+ (TestManager * _Nonnull)test SWIFT_WARN_UNUSED_RESULT;
/// The delegate that will be notified when Flyshot In-App Purchases occured
@property (nonatomic, weak) id <FlyshotDelegate> _Nullable delegate;
/// \param appsflyerId AppsFlyer identifier
///
@property (nonatomic, copy) NSString * _Nullable appsflyerId;
/// Existing user flag
@property (nonatomic) BOOL isExistingUser;
/// Initialize SDK
/// - Parameter sdkToken: license key
- (void)initializeWithSdkToken:(NSString * _Nonnull)sdkToken onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)initializeWithSdkToken:(NSString * _Nonnull)sdkToken;
/// Starts SDK
- (void)start;
/// Returns true/false boolean if user is associated with Flyshot
- (BOOL)isFlyshotUser SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot discount
- (BOOL)isEligibleForDiscountWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot discount
- (BOOL)isEligibleForDiscount SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot reward
- (BOOL)isEligibleForRewardWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot reward
- (BOOL)isEligibleForReward SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot promo
- (BOOL)isEligibleForPromoWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user has active campaign
- (BOOL)isCampaignActiveWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot promo
- (BOOL)isEligibleForPromo SWIFT_WARN_UNUSED_RESULT;
/// Scan for  Promo Screenshots
/// onComplete return true if active promo campaign was found
- (void)scanOnComplete:(void (^ _Nonnull)(BOOL))onComplete onFailure:(SWIFT_NOESCAPE void (^ _Nonnull)(NSError * _Nonnull))onFailure SWIFT_UNAVAILABLE_MSG("Use upload instead");
/// Upload for Promo Screenshots
/// onSuccess returns campaign status
- (void)uploadOnSuccess:(void (^ _Nonnull)(enum CampaignStatus))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
/// Fetch Active Campaign
- (void)getActiveCampaignOnSuccess:(void (^ _Nullable)(PromoCampaign * _Nullable))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure SWIFT_AVAILABILITY(ios,unavailable,message="Use content instead");
/// Returns an array of last uploaded content
- (void)getContentOnSuccess:(void (^ _Nullable)(NSArray<Post *> * _Nonnull))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Requests Promo View from  Flyshot’s configuration
- (void)requestPromoBanner;
/// Send ‘Conversion’ event to Flyshot Analytics
/// \param amount Amount value of conversion
///
/// \param productId Product identifier
///
/// \param currencyCode ISO currency code
///
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode productId:(NSString * _Nullable)productId onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode productId:(NSString * _Nullable)productId;
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode;
- (void)sendConversionEventWithAmount:(double)amount onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)sendConversionEventWithAmount:(double)amount;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendCustomEventWithName:(NSString * _Nonnull)name onSuccess:(void (^ _Nullable)(void))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
///
/// returns:
/// No return value
- (void)sendCustomEventWithName:(NSString * _Nonnull)name;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendEventWithName:(NSString * _Nonnull)name onSuccess:(void (^ _Nullable)(void))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
///
/// returns:
/// No return value
- (void)sendEventWithName:(NSString * _Nonnull)name;
/// Send ‘Sign Up’ event to Flyshot Analytics
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendSignUpEventOnSuccess:(void (^ _Nullable)(void))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Send ‘Sign Up’ event to Flyshot Analytics
///
/// returns:
/// No return value
- (void)sendSignUpEvent;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


@class SKPaymentQueue;
@class SKPaymentTransaction;

/// Implement this protocol to work with Flyshot In-App Purchases
SWIFT_PROTOCOL("_TtP10FlyshotSDK15FlyshotDelegate_")
@protocol FlyshotDelegate
/// Flyshot will rely on this method before invoking any in-app purchase
/// Implementations should contain logic to check if Flyshot should be allowed to show In-App Purchase alert for particular Product Identifier
- (BOOL)allowFlyshotPurchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier SWIFT_WARN_UNUSED_RESULT;
/// This method will be invoked as a callback on In-App Purchase event made by Flyshot
/// It will pass the same parameters as you would get from Apple StoreKit paymentQueue(_:updatedTransactions:) method
/// No need to finish transactions
- (void)flyshotPurchaseWithPaymentQueue:(SKPaymentQueue * _Nonnull)paymentQueue updatedTransactions:(NSArray<SKPaymentTransaction *> * _Nonnull)transactions;
/// Called when Flyshot campaign was detected.
/// \param productId Identifier of detected campaign
///
- (void)flyshotCampaignDetectedWithProductId:(NSString * _Nullable)productId;
@end



/// Class represented Promotional Content
SWIFT_CLASS("_TtC10FlyshotSDK4Post")
@interface Post : NSObject
/// Creator User Name
@property (nonatomic, readonly, copy) NSString * _Nonnull creatorHandle;
/// Creator Name
@property (nonatomic, readonly, copy) NSString * _Nonnull creatorName;
/// Image URL
@property (nonatomic, readonly, copy) NSURL * _Nullable imageURL;
/// Image thumbnail URL
@property (nonatomic, readonly, copy) NSURL * _Nullable thumbnailURL;
/// Socials image URL
@property (nonatomic, readonly, copy) NSURL * _Nullable postLink;
/// Caption
@property (nonatomic, readonly, copy) NSString * _Nonnull caption;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


/// Class represented Promotional Campaign
SWIFT_CLASS("_TtC10FlyshotSDK13PromoCampaign")
@interface PromoCampaign : NSObject
/// Campaign name
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
/// Promotional Title
@property (nonatomic, readonly, copy) NSString * _Nonnull promotionTile;
/// Promotional Application Name
@property (nonatomic, readonly, copy) NSString * _Nonnull applicationName;
/// List of Promotonal Content
@property (nonatomic, readonly, copy) NSArray<Post *> * _Nonnull content;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


/// Class for testing SDK functionality.
/// *API automaticaly disabled on production environment.
SWIFT_CLASS("_TtC10FlyshotSDK11TestManager")
@interface TestManager : NSObject
/// Set true to not redeem campaign on server.
@property (nonatomic) BOOL campaignRedeemTest;
/// Clear cached campaign’s data
- (void)clearCampaignData;
/// Clear cached user’s data
- (void)clearUserData;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end











#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#elif defined(__ARM_ARCH_7A__) && __ARM_ARCH_7A__
// Generated by Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
#ifndef FLYSHOTSDK_SWIFT_H
#define FLYSHOTSDK_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="FlyshotSDK",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

typedef SWIFT_ENUM(NSInteger, CampaignStatus, open) {
  CampaignStatusNotFound = 0,
  CampaignStatusFound = 1,
  CampaignStatusRedeemed = 2,
  CampaignStatusCanceled = 3,
};

@class TestManager;
@protocol FlyshotDelegate;
@class PromoCampaign;
@class Post;

/// Class providing Sdk functionality
SWIFT_CLASS("_TtC10FlyshotSDK7Flyshot")
@interface Flyshot : NSObject
/// Gets the singleton instance of a Flyshot.
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) Flyshot * _Nonnull shared;)
+ (Flyshot * _Nonnull)shared SWIFT_WARN_UNUSED_RESULT;
/// Gets the singleton instance of a TestManager
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) TestManager * _Nonnull test;)
+ (TestManager * _Nonnull)test SWIFT_WARN_UNUSED_RESULT;
/// The delegate that will be notified when Flyshot In-App Purchases occured
@property (nonatomic, weak) id <FlyshotDelegate> _Nullable delegate;
/// \param appsflyerId AppsFlyer identifier
///
@property (nonatomic, copy) NSString * _Nullable appsflyerId;
/// Existing user flag
@property (nonatomic) BOOL isExistingUser;
/// Initialize SDK
/// - Parameter sdkToken: license key
- (void)initializeWithSdkToken:(NSString * _Nonnull)sdkToken onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)initializeWithSdkToken:(NSString * _Nonnull)sdkToken;
/// Starts SDK
- (void)start;
/// Returns true/false boolean if user is associated with Flyshot
- (BOOL)isFlyshotUser SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot discount
- (BOOL)isEligibleForDiscountWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot discount
- (BOOL)isEligibleForDiscount SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot reward
- (BOOL)isEligibleForRewardWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot reward
- (BOOL)isEligibleForReward SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot promo
- (BOOL)isEligibleForPromoWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user has active campaign
- (BOOL)isCampaignActiveWithProductId:(NSString * _Nullable)productId SWIFT_WARN_UNUSED_RESULT;
/// Returns true/false boolean if user is eligible for Flyshot promo
- (BOOL)isEligibleForPromo SWIFT_WARN_UNUSED_RESULT;
/// Scan for  Promo Screenshots
/// onComplete return true if active promo campaign was found
- (void)scanOnComplete:(void (^ _Nonnull)(BOOL))onComplete onFailure:(SWIFT_NOESCAPE void (^ _Nonnull)(NSError * _Nonnull))onFailure SWIFT_UNAVAILABLE_MSG("Use upload instead");
/// Upload for Promo Screenshots
/// onSuccess returns campaign status
- (void)uploadOnSuccess:(void (^ _Nonnull)(enum CampaignStatus))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
/// Fetch Active Campaign
- (void)getActiveCampaignOnSuccess:(void (^ _Nullable)(PromoCampaign * _Nullable))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure SWIFT_AVAILABILITY(ios,unavailable,message="Use content instead");
/// Returns an array of last uploaded content
- (void)getContentOnSuccess:(void (^ _Nullable)(NSArray<Post *> * _Nonnull))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Requests Promo View from  Flyshot’s configuration
- (void)requestPromoBanner;
/// Send ‘Conversion’ event to Flyshot Analytics
/// \param amount Amount value of conversion
///
/// \param productId Product identifier
///
/// \param currencyCode ISO currency code
///
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode productId:(NSString * _Nullable)productId onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode productId:(NSString * _Nullable)productId;
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)sendConversionEventWithAmount:(double)amount currencyCode:(NSString * _Nullable)currencyCode;
- (void)sendConversionEventWithAmount:(double)amount onSuccess:(void (^ _Nonnull)(void))onSuccess onFailure:(void (^ _Nonnull)(NSError * _Nonnull))onFailure;
- (void)sendConversionEventWithAmount:(double)amount;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendCustomEventWithName:(NSString * _Nonnull)name onSuccess:(void (^ _Nullable)(void))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
///
/// returns:
/// No return value
- (void)sendCustomEventWithName:(NSString * _Nonnull)name;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendEventWithName:(NSString * _Nonnull)name onSuccess:(void (^ _Nullable)(void))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Send event ‘name’ to Flyshot Analytics
/// \param name name of custom action
///
///
/// returns:
/// No return value
- (void)sendEventWithName:(NSString * _Nonnull)name;
/// Send ‘Sign Up’ event to Flyshot Analytics
/// \param onSuccess A closure which is called when event sent  successfully
///
/// \param onFailure A closure which is called when event sent was failed with error
///
///
/// returns:
/// No return value
- (void)sendSignUpEventOnSuccess:(void (^ _Nullable)(void))onSuccess onFailure:(void (^ _Nullable)(NSError * _Nonnull))onFailure;
/// Send ‘Sign Up’ event to Flyshot Analytics
///
/// returns:
/// No return value
- (void)sendSignUpEvent;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


@class SKPaymentQueue;
@class SKPaymentTransaction;

/// Implement this protocol to work with Flyshot In-App Purchases
SWIFT_PROTOCOL("_TtP10FlyshotSDK15FlyshotDelegate_")
@protocol FlyshotDelegate
/// Flyshot will rely on this method before invoking any in-app purchase
/// Implementations should contain logic to check if Flyshot should be allowed to show In-App Purchase alert for particular Product Identifier
- (BOOL)allowFlyshotPurchaseWithProductIdentifier:(NSString * _Nonnull)productIdentifier SWIFT_WARN_UNUSED_RESULT;
/// This method will be invoked as a callback on In-App Purchase event made by Flyshot
/// It will pass the same parameters as you would get from Apple StoreKit paymentQueue(_:updatedTransactions:) method
/// No need to finish transactions
- (void)flyshotPurchaseWithPaymentQueue:(SKPaymentQueue * _Nonnull)paymentQueue updatedTransactions:(NSArray<SKPaymentTransaction *> * _Nonnull)transactions;
/// Called when Flyshot campaign was detected.
/// \param productId Identifier of detected campaign
///
- (void)flyshotCampaignDetectedWithProductId:(NSString * _Nullable)productId;
@end



/// Class represented Promotional Content
SWIFT_CLASS("_TtC10FlyshotSDK4Post")
@interface Post : NSObject
/// Creator User Name
@property (nonatomic, readonly, copy) NSString * _Nonnull creatorHandle;
/// Creator Name
@property (nonatomic, readonly, copy) NSString * _Nonnull creatorName;
/// Image URL
@property (nonatomic, readonly, copy) NSURL * _Nullable imageURL;
/// Image thumbnail URL
@property (nonatomic, readonly, copy) NSURL * _Nullable thumbnailURL;
/// Socials image URL
@property (nonatomic, readonly, copy) NSURL * _Nullable postLink;
/// Caption
@property (nonatomic, readonly, copy) NSString * _Nonnull caption;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


/// Class represented Promotional Campaign
SWIFT_CLASS("_TtC10FlyshotSDK13PromoCampaign")
@interface PromoCampaign : NSObject
/// Campaign name
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
/// Promotional Title
@property (nonatomic, readonly, copy) NSString * _Nonnull promotionTile;
/// Promotional Application Name
@property (nonatomic, readonly, copy) NSString * _Nonnull applicationName;
/// List of Promotonal Content
@property (nonatomic, readonly, copy) NSArray<Post *> * _Nonnull content;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


/// Class for testing SDK functionality.
/// *API automaticaly disabled on production environment.
SWIFT_CLASS("_TtC10FlyshotSDK11TestManager")
@interface TestManager : NSObject
/// Set true to not redeem campaign on server.
@property (nonatomic) BOOL campaignRedeemTest;
/// Clear cached campaign’s data
- (void)clearCampaignData;
/// Clear cached user’s data
- (void)clearUserData;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end











#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#endif

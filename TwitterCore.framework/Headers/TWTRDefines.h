//
//  TWTRDefines.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#pragma once

#if __has_feature(nullability)
    #define twtr_nullable           nullable
    #define twtr_nonnull            nonnull
    #define twtr_null_unspecified   null_unspecified
    #define twtr_null_resettable    null_resettable
    #define __twtr_nullable         __nullable
    #define __twtr_nonnull          __nonnull
    #define __twtr_null_unspecified __null_unspecified
#else
    #define twtr_nullable
    #define twtr_nonnull
    #define twtr_null_unspecified
    #define twtr_null_resettable
    #define __twtr_nullable
    #define __twtr_nonnull
    #define __twtr_null_unspecified
#endif

#define TWC_STR_HELPER(x) #x
#define TWC_STR(x) TWC_STR_HELPER(x)

#ifndef NS_ASSUME_NONNULL_BEGIN
    #define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef NS_ASSUME_NONNULL_END
    #define NS_ASSUME_NONNULL_END
#endif

#define IS_UIKIT_AVAILABLE (TARGET_OS_IOS || TARGET_OS_TV)
#define IS_SOCIAL_ACCOUNTS_AVAILABLE (TARGET_OS_MAC && !TARGET_OS_WATCH && !TARGET_OS_TV)

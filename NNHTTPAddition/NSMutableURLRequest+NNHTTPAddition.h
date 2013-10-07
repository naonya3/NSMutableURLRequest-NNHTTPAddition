//
//  NSMutableURLRequest+NNHTTPAddition.m
//
//  Created by Naoto Horiguchi on 2013/10/04.
//  Copyright (c) 2013年 Naoto Horiguchi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NNPostContentTypeForm,
    NNPostContentTypeMultiPart,
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    NNPostContentTypeJSON,
#endif
    NNPostContentTypeNone
} NNPostContentType;

typedef enum {
    NNHTTPMethodGET,
    NNHTTPMethodPOST,
    NNHTTPMethodPUT,
    NNHTTPMethodDELETE
} NNHTTPMethodType;

@interface NSMutableURLRequest (NNHTTPAddition)

+ (NSMutableURLRequest *)httpRequestWithURL:(NSURL *)url
                                 parameters:(NSDictionary *)parameters
                                    headers:(NSDictionary *)headerds
                                 httpMethod:(NNHTTPMethodType)httpMethod
                                contentType:(NNPostContentType)contentType;
@end

@interface NNMultiPartFileData : NSObject

@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSData *data;

@end

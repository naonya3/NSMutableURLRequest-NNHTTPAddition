//
//  NSMutableURLRequest+NNHTTPAddition.m
//
//  Created by Naoto Horiguchi on 2013/10/04.
//  Copyright (c) 2013年 Naoto Horiguchi. All rights reserved.
//

#import "NSMutableURLRequest+NNHTTPAddition.h"

static NSString * const kNNMultipartFormBoundary = @"Birthday19871006+60017891";

@implementation NSMutableURLRequest (NNHTTPAddition)

+ (NSMutableURLRequest *)httpRequestWithURL:(NSURL *)url
                                 parameters:(NSDictionary *)parameters
                                    headers:(NSDictionary *)headerds
                                 httpMethod:(NNHTTPMethodType)httpMethod
                                contentType:(NNPostContentType)contentType
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if (httpMethod == NNHTTPMethodGET || httpMethod == NNHTTPMethodDELETE) {
        NSString *urlStringWithParam = [url absoluteString];
        if (parameters) {
            NSString *query = [self _queryFromParameters:parameters];
            urlStringWithParam = [urlStringWithParam stringByAppendingFormat:@"?%@", query];
        }
        url = [NSURL URLWithString:urlStringWithParam];
    
    } else if (httpMethod == NNHTTPMethodPOST || httpMethod == NNHTTPMethodPUT) {
        if (contentType == NNPostContentTypeForm) {
            NSData *body = [[self _queryFromParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:body];
            [request setValue:@"application/x-www-form-urlencoded; charset-utf-8" forHTTPHeaderField:@"Content-Type"];
        }
        
        if (contentType == NNPostContentTypeMultiPart) {
            NSData *body = [self _multiPartDataFromParameters:parameters];
            [request setHTTPBody:body];
            [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",kNNMultipartFormBoundary] forHTTPHeaderField:@"Content-Type"];
        }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if (contentType == NNPostContentTypeJSON) {
            NSError *error;
            NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
            if (!error) {
                [request setHTTPBody:body];
                [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            }
        }
#endif

    }
    
    [request setURL:url];
    [request setAllHTTPHeaderFields:headerds];
    [request setHTTPMethod:[self _methodStringFromType:httpMethod]];
    return request;
}

+ (NSString *)_queryFromParameters:(NSDictionary *)parameters
{
    NSMutableArray *queries = @[].mutableCopy;
    for (NSString *key in parameters) {
        NSString *value = parameters[key];
        NSString *escapedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                            NULL,
                                                            (__bridge CFStringRef)value,
                                                            NULL,
                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                            kCFStringEncodingUTF8
                                                            ));
        [queries addObject:[NSString stringWithFormat:@"%@=%@", key, escapedValue]];
    }
    return [queries componentsJoinedByString:@"&"];
}

+ (NSData *)_multiPartDataFromParameters:(NSDictionary *)parameters
{
    NSMutableData *bodyData = nil;
    
    NSString *carriageReturnNewline = @"\r\n";
    NSString *contentBoundary = [NSString stringWithFormat:@"--%@\r\n", kNNMultipartFormBoundary];
    NSString *closingBoundary = [NSString stringWithFormat:@"--%@--\r\n", kNNMultipartFormBoundary];
    
    if ([parameters count] == 0) {
        return nil;
    }
    
    for (NSString *key in parameters) {
        if (bodyData == nil) {
            bodyData = [NSMutableData data];
        }
        id value = [parameters objectForKey:key];
        
        NSString *nameDispositionString = [NSString stringWithFormat:@"name=\"%@\"",key];
        NSMutableString *contentDispositionHeader = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; %@",
                                                     nameDispositionString];
        NSData *contentData = nil;
        NSString *contentTypeString = nil;
        
        if ([value isKindOfClass:[NNMultiPartFileData class]]) {
            NNMultiPartFileData *fileData = (NNMultiPartFileData *)value;
            
            NSString *filenameDispositionString = [NSString stringWithFormat:@"filename=\"%@\"", [fileData fileName]];
            [contentDispositionHeader appendString:[NSString stringWithFormat:@"; %@", filenameDispositionString]];
            if ([fileData mimeType]) {
                contentTypeString = [NSString stringWithFormat:@"Content-Type: %@",[fileData mimeType]];
            }
            contentData = [fileData data];
        }
        else if ([value isKindOfClass:[NSData class]]) {
            contentData = value;
        }
        else {
            contentData = [[value description] dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSMutableString *bodyString = [NSMutableString stringWithString:contentBoundary];
        [bodyString appendString:[NSString stringWithFormat:@"%@%@",contentDispositionHeader, carriageReturnNewline]];
        
        if (contentTypeString) {
            [bodyString appendString:[NSString stringWithFormat:@"%@%@",contentTypeString, carriageReturnNewline]];
        }
        [bodyString appendString:carriageReturnNewline];
        [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:contentData];
        [bodyData appendData:[carriageReturnNewline dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [bodyData appendData:[closingBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    return bodyData;
}

+ (NSString *)_methodStringFromType:(NNHTTPMethodType)type
{
    NSString *methodString = @"GET";
    switch (type) {
        case NNHTTPMethodGET:
            methodString = @"GET";
            break;
            
        case NNHTTPMethodPOST:
            methodString = @"POST";
            break;
            
        case NNHTTPMethodPUT:
            methodString = @"PUT";
            break;
            
        case NNHTTPMethodDELETE:
            methodString = @"DELETE";
            break;
    }
    return methodString;
}

@end

@implementation NNMultiPartFileData
@end

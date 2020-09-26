//
//  URLRouterAnalysis.m
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import "URLRouterUtil.h"

@implementation URLRouterUtil

+ (NSString *)encodeURLString:(NSString*)originString{
    if (originString == nil || [originString isEqualToString:@""]) {
        return @"";
    }
    
    NSMutableCharacterSet* set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    return [originString stringByAddingPercentEncodingWithAllowedCharacters:set];
}

// Mark - URLDecode
+ (NSString *)decodeURLString:(NSString*)encodedString{
    return [encodedString stringByRemovingPercentEncoding];
}

@end

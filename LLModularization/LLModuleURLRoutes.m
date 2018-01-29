//
//  LLModuleURLRoutes.m
//  AFNetworking
//
//  Created by 李林 on 12/14/17.
//

#import "LLModuleURLRoutes.h"

static NSString * const LL_ROUTER_WILDCARD_CHARACTER = @"~";
static NSString *specialCharacters = @"/?&.";

NSString *const LLRoutesrURL = @"LLRoutesrURL";
NSString *const LLRoutesStatus = @"LLRoutesStatus";
NSString *const LLRoutesService = @"LLRoutesService";
NSString *const LLRoutesParameters = @"LLRoutesParameters";


@interface LLModuleURLRoutes()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation LLModuleURLRoutes

#pragma mark - sharedInstance

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LLModuleURLRoutes *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LLModuleURLRoutes alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Lazy Load

- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

#pragma mark - register & deregister

+ (void)registerURLPattern:(NSString *)urlPattern
                 toService:(NSString *)serviceName {
    [[LLModuleURLRoutes sharedInstance] addURLPattern:urlPattern andServiceName:serviceName];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern {
    [[LLModuleURLRoutes sharedInstance] removeURLPattern:URLPattern];
}

#pragma mark - open

+ (NSDictionary *)openURL:(NSString *)url {
    return [self openURL:url withUserInfo:nil];
}

+ (NSDictionary *)openURL:(NSString *)url withUserInfo:(NSDictionary *)userInfo {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[self sharedInstance] extractParametersFromURL:url];
    
    NSMutableDictionary *infoDict = @{}.mutableCopy;
    if (userInfo.count > 0) {
        [infoDict addEntriesFromDictionary:userInfo];
    }
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if (key != LLRoutesService) {
            infoDict[key] = obj;
            [parameters removeObjectForKey:key];
        }
    }];
    
    // 拼接字典
    if (parameters) {
        parameters[LLRoutesStatus] = @"YES";
        if (infoDict) {
            parameters[LLRoutesParameters] = [infoDict copy];
        }
    } else {
        parameters[LLRoutesStatus] = @"NO";
    }
    
    return parameters;
}

#pragma mark - Private Methods

- (void)addURLPattern:(NSString *)URLPattern andServiceName:(NSString *)serviceName {
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (serviceName && subRoutes) {
        subRoutes[LLRoutesService] = serviceName;
    }
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern {
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSMutableDictionary* subRoutes = self.routes;
    
    for (NSString* pathComponent in pathComponents) {
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
    }
    return subRoutes;
}

/**
 只删除URLPattern的最后一级
 */
- (void)removeURLPattern:(NSString *)URLPattern {
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURL:URLPattern]];
    
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routes valueForKey:components];
        
        // 这route一定是一个Service的dictionary，在本程序逻辑上不存在没有Service的URLPattern，如果存在一定非法，那可以置之不理。
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根key
            route = self.routes;
            if (pathComponents.count > 0) {
                NSString *componentWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

#pragma mark - Utils

/**
 解析URL的参数
 参考：HHRouter(https://github.com/lightory/HHRouter)
 */
- (NSMutableDictionary *)extractParametersFromURL:(NSString *)URL {
    NSMutableDictionary *params = @{}.mutableCopy;
    
    // 1. 解析URL中 :id的参数
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromURL:URL];
    
    BOOL found = NO;
    for (NSString *pathComponent in pathComponents) {
        
        // 1.1 对routes中的key排序，把特殊字符~过渡到最后面去
        NSArray *subRoutesKeys = [subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        // 1.2 遍历routes中所有的key
        for (NSString *key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:LL_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                
                // 1.2.3 处理特殊情况 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        newKey = [newKey substringToIndex:range.location-1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                params[newKey] = newPathComponent;
                break;
            }
        }
    }
    
    // 2. 解析URL中的query参数
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:URL] resolvingAgainstBaseURL:false].queryItems;
    
    for (NSURLQueryItem *item in queryItems) {
        params[item.name] = item.value;
    }
    
    if (subRoutes[LLRoutesService]) {
        params[LLRoutesService] = [subRoutes[LLRoutesService] copy];
    }
    
    return params;
}

- (NSArray *)pathComponentsFromURL:(NSString*)URL {
    NSMutableArray *pathComponents = @[].mutableCopy;
    
    // 把URL的Scheme存放下来
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，存放一个占位符。
        URL = pathSegments.lastObject;
        if (!URL.length) {
            [pathComponents addObject:LL_ROUTER_WILDCARD_CHARACTER];
        }
    }
    
    // ?和/都没有执行过，不了解原作者的意图。
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    
    return [pathComponents copy];
}

+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
}

@end

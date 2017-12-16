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
    
    NSMutableDictionary *infoDict = userInfo.mutableCopy;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        if (key != LLRoutesService) {
            [infoDict setObject:obj forKey:key];
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

- (void)removeURLPattern:(NSString *)URLPattern {
    // TODO:周一重新整理register和deregister以及safePerform，同时测试一下Module内两个VC是否可以相互打开。和强哥交流一下链路系统需要做成什么样子。
    
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURL:URLPattern]];
    
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routes valueForKeyPath:components];
        
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routes;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

#pragma mark - Utils

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
//    parameters[LLRoutesrURL] = url;
    
    NSMutableDictionary* subRoutes = self.routes;
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    BOOL found = NO;
    // 参考 HHRouter(https://github.com/lightory/HHRouter)
    for (NSString* pathComponent in pathComponents) {
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:LL_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
                break;
            }
        }
        
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[LLRoutesService]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:[[NSURL alloc] initWithString:url] resolvingAgainstBaseURL:false].queryItems;
    
    for (NSURLQueryItem *item in queryItems) {
        parameters[item.name] = item.value;
    }
    
    if (subRoutes[LLRoutesService]) {
        parameters[LLRoutesService] = [subRoutes[LLRoutesService] copy];
    }
    
    return parameters;
}

- (NSArray*)pathComponentsFromURL:(NSString*)URL {
    NSMutableArray *pathComponents = [NSMutableArray array];
    
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        URL = pathSegments.lastObject;
        if (!URL.length) {
            [pathComponents addObject:LL_ROUTER_WILDCARD_CHARACTER];
        }
    }
    
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

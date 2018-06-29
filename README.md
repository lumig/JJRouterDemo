# JJRouterDemo

iOS组件化曾今在业界是多么的火热的话题，现在在少有人再次提及这个的话题。网上也很多关于组件化的文章和思想，最经典的要是casa大神和蘑菇街关于组件化的论战。想想曾今看到这些文章的时候，觉得组件化是多么优秀的思想，觉得他们说的都有道理，而casa大神应该在很多思想上给了我等码农很多灵感。而两位大神架构师级别的论剑是否让你真正理解到组件化的重要性。是否让你在内心深处产生共鸣，最 近看到一个项目让我对组件化多了些思考。

一、为什么要组件化，组件化到底有什么好处？
为什么要组件化，在看过很多优秀的文章后，你一定会问这个问题，组件化能给我们带来多大的好处？作为一个小公司而言，涉及组件化的机会很少，没有大厂的工作经验，也很难将组件化理解的很透彻。可能以为我们的业务模块还不够多，或者说，我们没有理解到他的好处，其实组件化最大的好处就是，每个组件，每个模块都可能单独成一个app，具有自己的生命周期。这样就可以分割成不同的业务组模块去处理，之前听说京东，有团队专门负责消息模块，有团队专门负责广告模块，有团队专门负责发现模块，这是你就会发现如果没有很好的组件化思想，这样的多团队合作就非常的困难，已经很难维护好这个项目的开发迭代。说了这么多，到底组件化是什么样子的呢？那我跟着我的脚步，学习分析，探讨下。

二、组件化的核心思想
组件化的话的核心思想，也是我们进行组件化的基础框架，就是通过怎么样的方式实现组件化，或者如何从架构层，业务层多个层次实现架构呢。要想实现组件化，其实就是建立一个中间转换的工具。你也可以理解为路由，通过路由的思想实现跨业务的数据沟通，从而一定程度上的降低各层数据的耦合。减少各个业务层等层级的import发生的耦合。

三、目前实现的组件化的方式
目前实现一般有下面三种思想：
1.Procotol方案
2.URL路由方案
3.target-action方案

Procotol协议注册方案
关于procotol协议注册方案看人用的比较少，也很少看到有人分享，我也是在这个项目中看到，就研究了一下。通过JJProtocolManager 作为中间转化。

```
+ (void)registerModuleProvider:(id)provider forProtocol:(Protocol*)protocol;
+ (id)moduleProviderForProtocol:(Protocol *)protocol;
```
所有组件对外提供的procotol和组件提供的服务由中间件统一管理，每个组件提供的procotol和服务是一一对应的。
例如：
在JJLoginProvider中:load方法会应用启动的时候调用，就会在JJProtocolManager进行注册。JJLoginProvider遵守了JJLoginProvider协议，这样就可以对外根据业务需求提供一些方法。

```
+ (void)load
{
[JJProtocolManager registerModuleProvider:[self new] forProtocol:@protocol(JJLoginProtocol)];
}
- (UIViewController *)viewControllerWithInfo:(id)userInfo needNew:(BOOL)needNew callback:(JJModuleCallbackBlock)callback{
CLoginViewController *vc = [[CLoginViewController alloc] init];
vc.jj_moduleCallbackBlock = callback;
vc.jj_moduleUserInfo = userInfo;
return vc;
}

```

这样就可以在需要登录业务模块的地方，通过JJProtocolManager取出JJLoginProtocol对应的服务提供者JJLoginProvider，直接获取。如下：

```
id<JJWebviewVCModuleProtocol> provider = [JJProtocolManager moduleProviderForProtocol:@protocol(JJWebviewVCModuleProtocol)];
UIViewController *vc =[provider viewControllerWithInfo:obj needNew:YES callback:^(id info) {
if (callback) {
callback(info);
}
}];
vc.hidesBottomBarWhenPushed = YES;
[self.currentNav pushViewController:vc animated:YES];
```

URL路由方案
URL路由方案最经典的就是蘑菇街的路由组件化，通过url的方式将调用方法，调用参数，已经回调方法封装到url中，然后在通过对url的解析获取到方法名，参数，最后通过消息转发机制调用方法。
下面是蘑菇街的路由方式：（这里要是想详细了解，可以到[蘑菇街的路由组件化](http://limboy.me/tech/2016/03/10/mgj-components.html) 中具体学习）
```
[MGJRouter registerURLPattern:@"mgj://detail?id=:id" toHandler:^(NSDictionary *routerParameters) {
NSNumber *id = routerParameters[@"id"];
// create view controller with id
// push view controller
}];
```
首页只需调用 [MGJRouter openURL:@"mgj://detail?id=404"] 就可以打开相应的详情页。
这里可以看到，我们通过url短链的方式，通过将参数拼接到url query部分，这样就可以，通过这样解析url中的scheme,host,path,query获取到调转什么要的控制器，需要传什么什么样的参数，从而push或者present新页面。
解析scheme,host,path核心代码
```
NSString *scheme = [nsUrl scheme];//解析scheme
NSString *module = [nsUrl host];
NSString *action = [[nsUrl path] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
if (action && [action length] && [action hasPrefix:@"_"]) {
action = [action stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
}

NSString *query = nil;
NSArray* pathInfo = [nsUrl.absoluteString componentsSeparatedByString:@"?"];
if (pathInfo.count > 1) {
query = [pathInfo objectAtIndex:1];
}
```

解析query的核心代码
```
NSMutableDictionary *parameters = nil;
NSString *parametersString = query;
NSArray *paramStringArr = [parametersString componentsSeparatedByString:@"&"];
if (paramStringArr && [paramStringArr count]>0) {
parameters = [NSMutableDictionary dictionary];
for (NSString* paramString in paramStringArr) {
NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
if (paramArr.count > 1) {
NSString *key = [paramArr objectAtIndex:0];
NSString *value = [paramArr objectAtIndex:1];
parameters[key] = [JJRouter unescapeURIComponent:value];
}
}
}
return parameters;
```
通过这样的方式，我们就可以实现组件化，但是有时候我们会遇到一个图片编辑模块，不能传递UIImage到对应的模块上去的话，这里我们需要传个新的参数进去，为了解决这个问题，这样其实，可以把参数直接丢给后面的arg处理

```
+ (nullable id)openURL:(nonnull NSString *)urlString arg:(nullable id)arg error:( NSError*__nullable *__nullable)error completion:(nullable JJRouterCompletion)completion

```

举个例子：
```
Action *action = [Action new];
action.type = JJ_WebView;
Params *params = [[Params alloc] init];
//            params.pageID = JJ_LOGIN;
action.params = params;
NSDictionary *parms = @{Jump_Key_Action:action, Jump_Key_Param : @{WebUrlString:@"http://www.baidu.com",Name:@"小二"}, Jump_Key_Callback:[JJFunc callback:^(id  _Nullable object) {
NSLog(@"%@",object);
}]};
//            ActionJump(parms);

[JJRouter openURL:@"router://JJActionService/showWebVC" arg: parms error:nil completion:parms[Jump_Key_Callback]];

}

```
我看的项目，这个就是通过url解析和protocol协议注册实现组件化,只是没有像蘑菇街那样注册支持哪些 URL类型。

target-action方案

target-action方案是在学习casa大神，[CTMediator](https://casatwy.com/iOS-Modulization.html) 的基础上进行的
casa大神认为，
1.根本无法表达非常规对象，如果用url组件化的话，遇到像UIImage这样的参数，就需要添加一个参数，才能解决
2.URL注册对于实施组件化方案是完全不必要的，且通过URL注册的方式形成的组件化方案，拓展性和可维护性都会被打折
3.蘑菇街没有拆分远程调用和本地间调用
4.蘑菇街必须要在app启动时注册URL响应者

```
//理论上页面之间的跳转只需 open 一个 URL 即可。所以对于一个组件来说，只要定义「支持哪些 URL」即可，比如详情页，大概可以这么做的
[MGJRouter registerURLPattern:@"mgj://detail?id=:id" toHandler:^(NSDictionary *routerParameters) {
NSNumber *id = routerParameters[@"id"];
// create view controller with id
// push view controller
}];
```
而casa的组件化主要是基于Mediator模式和Target-Action模式，中间采用了runtime来完成调用。这套组件化方案将远程应用调用和本地应用调用做了拆分，而且是由本地应用调用为远程应用调用提供服务，与蘑菇街方案正好相反。

调用方式：

先说本地应用调用，本地组件A在某处调用[[CTMediator sharedInstance] performTarget:targetName action:actionName params:@{...}]向CTMediator发起跨组件调用，CTMediator根据获得的target和action信息，通过objective-C的runtime转化生成target实例以及对应的action选择子，然后最终调用到目标业务提供的逻辑，完成需求。

在远程应用调用中，远程应用通过openURL的方式，由iOS系统根据info.plist里的scheme配置找到可以响应URL的应用（在当前我们讨论的上下文中，这就是你自己的应用），应用通过AppDelegate接收到URL之后，调用CTMediator的openUrl:方法将接收到的URL信息传入。当然，CTMediator也可以用openUrl:options:的方式顺便把随之而来的option也接收，这取决于你本地业务执行逻辑时的充要条件是否包含option数据。传入URL之后，CTMediator通过解析URL，将请求路由到对应的target和action，随后的过程就变成了上面说过的本地应用调用的过程了，最终完成响应。

针对请求的路由操作很少会采用本地文件记录路由表的方式，服务端经常处理这种业务，在服务端领域基本上都是通过正则表达式来做路由解析。App中做路由解析可以做得简单点，制定URL规范就也能完成，最简单的方式就是scheme://target/action这种，简单做个字符串处理就能把target和action信息从URL中提取出来了。

举个例子：
```
/**
这里是登录模块的target
**/
#import "CTMediator+ModuleLogin.h"
NSString * const kCTMediatorTargetA = @"A";
NSString * const kCTMediatorActionLoginViewController = @"showLoginController";

@implementation CTMediator (ModuleLogin)

- (UIViewController *)push_viewControllerForLogin
{
UIViewController *vc = [self performTarget:kCTMediatorTargetA action:kCTMediatorActionLoginViewController params:nil shouldCacheTarget:NO];

if ([vc isKindOfClass:[UIViewController class]]) {
// view controller 交付出去之后，可以由外界选择是push还是present
return vc;
} else {
// 这里处理异常场景，具体如何处理取决于产品
return [[UIViewController alloc] init];
}
}
```

```
/**
登录模块的action
**/
- (UIViewController *)Action_showLoginController:(NSDictionary *)param
{
JJLoginViewController *vc =[[JJLoginViewController alloc] init];

return vc;
}
```

看上去，target-action路由方案更加的清晰，不过这个还是各取所需吧

接下来，target-action的核心代码就是
```
/**
if ([target respondsToSelector:action])
判断target能否响应action方法，只要能够就执行这段核心代码，
核心代码的主要功能：
**/
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
//// 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
if(methodSig == nil) {
return nil;
}
//    获取返回类型
const char* retType = [methodSig methodReturnType];
//判断返回值类型
if (strcmp(retType, @encode(void)) == 0) {
// 通过签名初始化
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
//如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
[invocation setArgument:&params atIndex:2];
// 设置selector
[invocation setSelector:action];
// 设置target
[invocation setTarget:target];
//消息调用
[invocation invoke];
return nil;
}

if (strcmp(retType, @encode(NSInteger)) == 0) {
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
[invocation setArgument:&params atIndex:2];
[invocation setSelector:action];
[invocation setTarget:target];
[invocation invoke];
NSInteger result = 0;
[invocation getReturnValue:&result];
return @(result);
}

if (strcmp(retType, @encode(BOOL)) == 0) {
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
[invocation setArgument:&params atIndex:2];
[invocation setSelector:action];
[invocation setTarget:target];
[invocation invoke];
BOOL result = 0;
[invocation getReturnValue:&result];
return @(result);
}

if (strcmp(retType, @encode(CGFloat)) == 0) {
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
[invocation setArgument:&params atIndex:2];
[invocation setSelector:action];
[invocation setTarget:target];
[invocation invoke];
CGFloat result = 0;
[invocation getReturnValue:&result];
return @(result);
}

if (strcmp(retType, @encode(NSUInteger)) == 0) {
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
[invocation setArgument:&params atIndex:2];
[invocation setSelector:action];
[invocation setTarget:target];
[invocation invoke];
NSUInteger result = 0;
[invocation getReturnValue:&result];
return @(result);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}
```

总结：
CTMediator根据获得的target和action信息，通过objective-C的runtime转化生成target实例以及对应的action选择子，然后最终调用到目标业务提供的逻辑，完成需求。

下面是三种方式的代码实现Git的地址：
https://github.com/lumig/JJRouterDemo


彩蛋：
```
// url 编码格式
foo://example.com:8042/over/there?name=ferret#nose
\_/ \______________/ \________/\_________/ \__/
|         |              |         |        |
scheme authority         path      query   fragment

scheme://host.domain:port/path/filename
scheme - 定义因特网服务的类型。最常见的类型是 http
host - 定义域主机（http 的默认主机是 www）
domain - 定义因特网域名，比如 w3school.com.cn
:port - 定义主机上的端口号（http 的默认端口号是 80）
path - 定义服务器上的路径（如果省略，则文档必须位于网站的根目录中）。
filename - 定义文档/资源的名称
```



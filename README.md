# SELUpdateAlert
快捷添加版本更新提示



![非强制更新](https://upload-images.jianshu.io/upload_images/145010-01cec8386b907bcd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![强制更新](https://upload-images.jianshu.io/upload_images/145010-15edc276df78bf02.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

一句话快捷添加版本更新提示

    /** 添加更新提示 */
    [SELUpdateAlert showUpdateAlertWithVersion:@"版本号" Description:@"版本描述" updateType:YES];

    updateType :YES强制更新 NO非强制更新


强制更新使用后，业务逻辑：
当从接口判断出是否强制更新后，保存变量到本地，然后在：
appdelegate.m类中


```
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    NSLog(@"已退出app");
    //当从接口判断是强制更新，保证只要进入app，就会提示强制更新
    if ([Utils getMustUpdate]) {
        exit(0);
    }
}
```

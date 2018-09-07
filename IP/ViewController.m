//
//  ViewController.m
//  IP
//
//  Created by Johnson on 2018/8/8.
//  Copyright © 2018 Johnson. All rights reserved.
//

#import "ViewController.h"
#import <arpa/inet.h>
#import <ifaddrs.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelIp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAddressInfo) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self updateAddressInfo];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateAddressInfo
{
    self.labelIp.text = [self getIPAddressInfo].description;
}

- (NSDictionary *)getIPAddressInfo
{
    NSMutableDictionary *ens = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;

    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    ens[@"en0-WIFI"] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)] ?: [NSNull null];
                }
                else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"]) {
                    ens[@"en1-DATA"] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)] ?: [NSNull null];
                }
                else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en2"]) {
                    ens[@"en2-USB"] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)] ?: [NSNull null];
                }
                else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en3"]) {
                    ens[@"en3-BLUETOOTH"] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)] ?: [NSNull null];
                }
                else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en4"]) {
                    ens[@"en4"] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)] ?: [NSNull null];
                }
                else if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en5"]) {
                    ens[@"en5"] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)] ?: [NSNull null];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }

    // Free memory
    freeifaddrs(interfaces);
    return ens;
}


//    Class c = NSClassFromString(@"LSApplicationWorkspace");
//
//    id s = [(id)c performSelector:NSSelectorFromString(@"defaultWorkspace")];
//
//    NSArray * arr = [s performSelector:NSSelectorFromString(@"allInstalledApplications")];
//
//    for (id item in arr) {
//
//        NSString *indentifier = [item performSelector:NSSelectorFromString(@"applicationIdentifier")];
//        NSURL *bundleURL = [item valueForKey:@"bundleURL"];
//        if ([bundleURL.absoluteString hasSuffix:@"WeChat.app"]) {
//
//            NSLog(@"indentifier %@    ..",indentifier);
//
//            NSLog(@" app版本  %@",[item performSelector:NSSelectorFromString(@"shortVersionString")]);
//
//            NSLog(@" app build版本   %@",[item performSelector:NSSelectorFromString(@"bundleVersion")]);
//
//        }
//    }
@end

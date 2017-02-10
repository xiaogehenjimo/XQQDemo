//
//  XQQNetworkSpeed.m
//  wangsu
//
//  Created by XQQ on 2017/2/10.
//  Copyright © 2017年 UIP. All rights reserved.
//

#import "XQQNetworkSpeed.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

static long long   current;

@implementation XQQNetworkSpeed

/*获取网络流量信息*/
+ (NSString*)getInterfaceBytes{
    
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1){
        
        return 0;
    }
    
    uint32_t iBytes = 0;
    
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next){
        
        if (AF_LINK != ifa->ifa_addr->sa_family)
            
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            
            continue;
    
        if (ifa->ifa_data == 0)
            
            continue;

        if (strncmp(ifa->ifa_name, "lo", 2)){
            
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
        }
    }
    
    freeifaddrs(ifa_list);
    
    long long hehe = iBytes + oBytes;
    
    //与当前的进行对比
    long long sudu = current == 0 ? 0 : hehe - current;
    
    current = hehe;
    
    if (sudu < 1024) {//小于1K
        
        return [NSString stringWithFormat:@"%lldB/S",sudu];
        
    }else if(sudu < 1024 * 1024){//大于等于1K < 1M
        
        return [NSString stringWithFormat:@"%.2fK/S",sudu/1024.0];
        
    }else{//大于等于 1M < 1G
        return [NSString stringWithFormat:@"%.2fM/S",sudu/1024.0/1024.0];
    }
}
@end

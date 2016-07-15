//
//  XRNetCenter.m
//  XUER
//
//  Created by 韩占禀 on 15/8/26.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRNetCenter.h"
#import "AFNetworking.h"
#import "JSONKit.h"

static XRNetCenter *_netCenter = nil;

@implementation XRNetCenter

+(XRNetCenter *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netCenter = [[XRNetCenter alloc] init];
    });
    return _netCenter;
}

-(void)sendRequestWithNetType:(enum XRNetType)type withParams:(NSDictionary *)params withImagePath:(NSString *)imagePath withCompletion:(RequestCompletion)completion
{
    NSMutableDictionary *tmpParams = [NSMutableDictionary dictionaryWithDictionary:params];
    switch (type)
    {
        case XRNetType_userins:
        {
            tmpParams[kAct] = @"userins";
        }
            break;
        case XRNetType_useredit:
        {
            tmpParams[kAct] = @"useredit";
        }
            break;
        case XRNetType_userlogin:
        {
            tmpParams[kAct] = @"userlogin";
        }
            break;
        case XRNetType_userFindPsw:
        {
            tmpParams[kAct] = @"pwedit";
        }
            break;
        case XRNetType_userGetCode:
        {
            tmpParams[kAct] = @"phonecode";
        }
            break;
        case XRNetType_typelist:
        {
            tmpParams[kAct] = @"typelist";
        }
            break;
        case XRNetType_courselist:
        {
            tmpParams[kAct] = @"courselist";
        }
            break;
        case XRNetType_is_reg:
        {
            tmpParams[kAct] = @"is_reg";
        }
            break;
        case XRNetType_joincourse:
        {
            tmpParams[kAct] = @"joincourse";
        }
            break;
        case XRNetType_courseinfo:
        {
            //tmpParams[kAct] = @"courseinfo";
            tmpParams[kAct] = @"courseinfo_new";
        }
            break;
        case XRNetType_coursecommentadd:
        {
            tmpParams[kAct] = @"coursecommentadd";
        }
            break;
        case XRNetType_coursecomment:
        {
            tmpParams[kAct] = @"coursecomment";
        }
            break;
        case XRNetType_checkupdate:
        {
            tmpParams[kAct] = @"checkupdate";
        }
            break;
        case XRNetType_bannerlist:
        {
            tmpParams[kAct] = @"bannerlist";
        }
            break;
        case XRNetType_joincourse_z:
        {
            tmpParams[kAct] = @"joincourse_z";
        }
            break;
        case XRNetType_searchlist:
        {
            tmpParams[kAct] = @"serchlist";
        }
            break;
        case XRNetType_indexlist:
        {
            tmpParams[kAct] = @"indexlist";
        }
            break;
        case XRNetType_yijian:
        {
            tmpParams[kAct] = @"yijian";
        }
            break;
        case XRNetType_hotsearchwords:
        {
            tmpParams[kAct] = @"serchkey";
        }
            break;
        case XRNetType_messagelist:
        {
            tmpParams[kAct] = @"wdxx";
        }
            break;
        case XRNetType_messageinfo:
        {
            tmpParams[kAct] = @"wdxx_info";
        }
            break;
            
        default:
            break;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:kBaseUrl parameters:tmpParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([imagePath length] > 0)
        {
            NSURL *filePath = [NSURL fileURLWithPath:imagePath];
            [formData appendPartWithFileURL:filePath name:@"img" error:nil];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[responseObject JSONString]);
        completion(responseObject[kData],[responseObject[kStatus] intValue],nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@\nresponseString: -----------%@", error,operation.responseString);
        if (error.code == -1005)//网络链接失败重新调用这个方法
        {
            [self sendRequestWithNetType:type withParams:params withImagePath:imagePath withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
                completion(responseData,status,error);
            }];
        }
        completion(nil,-1,error);
    }];
    
}

@end

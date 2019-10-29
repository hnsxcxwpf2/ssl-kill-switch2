//
//  skfly_utility.c
//  CACript
//
//  Created by changyuhudong on 2018/6/1.
//  Copyright © 2018年 梦拓科技. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "skfly_utility.h"

#include <stdio.h>
#include <stdarg.h>
#include <time.h>

#import <arpa/inet.h>

#import <pthread.h>

#include <sys/syscall.h>

#import <objc/NSObject.h>

NSString* g_skfly_getNowTimeTimestampMsStr()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

long long g_skfly_getNowTimeTimestampMsLong()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeInterval interval =[datenow timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    return totalMilliseconds;
}


NSString* g_skfly_phone_name=@"未定义";
NSString* g_skfly_udid=@"未定义";
NSString* g_skfly_program_name=@"未定义";
long long g_skfly_instance_id=-1;


int skfly_write_to_net_http(const char* fileName,int lineNo,const char* funcName,NSString *content)
{
    @synchronized(g_skfly_program_name)
    {

        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/__SKFLY/SKFLY_DEBUG"])
        {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

            NSString* hostIP=[NSString stringWithContentsOfFile:@"/__SKFLY/SKFLY_DEBUG" encoding:NSUTF8StringEncoding error:nil];	//
            NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];

            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
            NSString *date =  [formatter stringFromDate:[NSDate date]];
            NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
            pthread_t tempPT=pthread_self();
            content=[content stringByReplacingOccurrencesOfString:@"&" withString:@"(and)"];

            NSProcessInfo *pInfo = [NSProcessInfo processInfo];  // 获取当前进程
            //NSString* urlStr=[NSString stringWithFormat:@"http://%@/log_net_ios/add?filename=%@&msg=[%@][%@][%@(%d:%lu:%d)][%@][%@][%s(%d)-%s][%@]",hostIP,g_skfly_program_name, timeLocal,readUuid(),g_skfly_program_name,getpid(),tempPT->__sig,syscall(SYS_gettid),[NSThread currentThread],[[NSBundle mainBundle] bundleIdentifier],fileName,lineNo,funcName,content];

            NSString* urlStr=[NSString stringWithFormat:@"http://%@/log_net_ios/add?ios_time=%@&log_level=%d&phone_name=%@&udid=%@&package_name=%@&program_name=%@&instance_id=%llu&process_id=%d&process_info=%@&thread_id=%lu|%d&thread_info=%@&file_name=%s&function_name=%s&line_no=%d&call_stack_info=[callStackSymbols:%@][callStackReturnAddresses:%@]&content=%@",
                                       hostIP,timeLocal,1,g_skfly_phone_name,g_skfly_udid,[[NSBundle mainBundle] bundleIdentifier],g_skfly_program_name,g_skfly_instance_id,getpid(),pInfo.processName,tempPT->__sig,syscall(SYS_gettid),[NSThread currentThread],fileName,funcName,lineNo,[NSThread callStackSymbols],[NSThread callStackReturnAddresses],content];
            //NSString* urlStr=[NSString stringWithFormat:@"http://%@/log_net_ios/add?ios_time=%@&log_level=%d&phone_name=%@&udid=%@&package_name=%@&program_name=%@&process_id=%d&process_info=%@&thread_id=%lu|%d&thread_info=%@&file_name=%s&function_name=%s&line_no=%d&call_stack_info=[callStackSymbols:%@][callStackReturnAddresses:%@]&content=%@",
            //hostIP,timeLocal,1,g_skfly_phone_name,g_skfly_udid,[[NSBundle mainBundle] bundleIdentifier],g_skfly_program_name,getpid(),pInfo.processName,tempPT->__sig,syscall(SYS_gettid),[NSThread currentThread],fileName,funcName,lineNo,[NSThread callStackSymbols],[NSThread callStackReturnAddresses],content];

            //readUuid(),g_skfly_program_name,getpid(),tempPT->__sig,syscall(SYS_gettid),[NSThread currentThread],[[NSBundle mainBundle] bundleIdentifier],fileName,lineNo,funcName,content];

            //NSString* urlStr=[NSString stringWithFormat:@"http://%@/kassdswewd/hello/addLog?programName=%@&content=[%@][%@][%@(%d:%lu:%d)][%@][%@][%s(%d)-%s][%@]",hostIP,g_skfly_program_name, timeLocal,readUuid(),g_skfly_program_name,getpid(),tempPT->__sig,syscall(SYS_gettid),[NSThread currentThread],[[NSBundle mainBundle] bundleIdentifier],fileName,lineNo,funcName,content];

            //NSLog(@"%@",urlStr);
            urlStr = [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url=[NSURL URLWithString:urlStr];

            NSError * testError = nil;

            NSString * status = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&testError];

            if (status == nil || [status isEqualToString:@""])
            {
                //NSLog(@"[%s(%d)-(%s)]:发送日志到服务器失败！！！！！",__FILE__,__LINE__,__FUNCTION__);
                return 0;
            }
            /**/
            //NSData * data = [status dataUsingEncoding:NSUTF8StringEncoding];
            //NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"retCode=%@",str);

        }
    }

    return 1;
}


int DEL_skfly_write_to_net_http2(const char* fileName,int lineNo,const char* funcName,char *format, ...)
{

    va_list args;
    va_start(args, format);
    NSString* content=([NSString stringWithFormat:[NSString stringWithUTF8String:format],args]);
    va_end(args);

    /*
     time_t time_log = time(NULL);
     struct tm* tm_log = localtime(&time_log);
     */
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];

    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    NSString* urlStr=[NSString stringWithFormat:@"http://test.99asm.com/AddLog.ashx?msg=[%@][%@][%@][%s(%d)-%s][%@]", timeLocal,g_skfly_program_name,[[NSBundle mainBundle] bundleIdentifier],fileName,lineNo,funcName,content];

    NSLog(@"%@",urlStr);
    urlStr = [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",urlStr);
    NSURL* url=[NSURL URLWithString:urlStr];

    NSError * testError = nil;
    NSString * status = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&testError];

    if (status == nil || [status isEqualToString:@""])
    {
        NSLog(@"status == nil");
        return 0;
    }

    NSData * data = [status dataUsingEncoding:NSUTF8StringEncoding];
    NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"retCode=%@",str);

    return 1;
}

int DEL_skfly_write_to_net(NSString* content)
{

    //1.创建scoket
    int _clientSocketId = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"%d",_clientSocketId);

    //2.连接服务器
    struct sockaddr_in addr;
    //初始化
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(15679);
    /*
     设置地址：
     1.地址类型
     2.地址字符串
     3.将要设置的地址变量
     */
    //连接到服务器端的地址
    inet_pton(AF_INET,"127.0.0.1", &addr.sin_addr);

    int connectId = connect(_clientSocketId, ( struct sockaddr*)&addr, sizeof(addr));
    if (connectId == -1)
    {
        NSLog(@"connect error");
    }

    //char strTemp[]="heheheheheh";
    //long sendId = send(_clientSocketId, strTemp, strlen(strTemp), 0);

    char buf[1024];
    time_t time_log = time(NULL);
    struct tm* tm_log = localtime(&time_log);
    sprintf(buf, "%04d-%02d-%02d %02d:%02d:%02d  %s", tm_log->tm_year + 1900, tm_log->tm_mon + 1, tm_log->tm_mday, tm_log->tm_hour, tm_log->tm_min, tm_log->tm_sec,[content UTF8String]);

    long sendId = send(_clientSocketId, buf, strlen(buf), 0);
    if (sendId == -1)
    {
        NSLog(@"send error");
    }
    close(_clientSocketId);
    return 1;
}


int DEL_skfly_write_to_file(NSString* filePath,NSString* content)
{
    if(filePath==NULL)
    {

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSLog(@"LOG_SKFLY  app_home_doc: %@",documentsDirectory);

        filePath = [documentsDirectory stringByAppendingPathComponent:@"test.txt"];
    }
    NSString* tempStr=[NSString stringWithFormat:@"%@%@\r\n",[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil],content];
    [tempStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return 1;
}

int DEL_write_log (const char* filePath,const char *format, ...)
{
    FILE* pFile=fopen(filePath, "a");

    va_list arg;
    int done;

    va_start (arg, format);

    time_t time_log = time(NULL);
    struct tm* tm_log = localtime(&time_log);
    fprintf(pFile, "%04d-%02d-%02d %02d:%02d:%02d ", tm_log->tm_year + 1900, tm_log->tm_mon + 1, tm_log->tm_mday, tm_log->tm_hour, tm_log->tm_min, tm_log->tm_sec);

    done = vfprintf (pFile, format, arg);
    va_end (arg);

    fflush(pFile);
    fclose(pFile);
    return done;
}

/*
 int main()
 {
 write_log( "%s %d %f\n", "is running", 10, 55.55);

 return 0;
 }
 */




NSData* convertHexStrToData(NSString *str)
{
    if (!str || [str length] == 0)
    {
        return nil;
    }

    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0)
    {
        range = NSMakeRange(0, 2);
    }
    else
    {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2)
    {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];

        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];

        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


NSString* convertDataToHexStr(NSData * data)
{
    if (!data || [data length] == 0)
    {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop)
         {
             unsigned char *dataBytes = (unsigned char*)bytes;
             for (NSInteger i = 0; i < byteRange.length; i++)
        {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2)
            {
                [string appendString:hexStr];
            }
            else
            {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

NSDate* convertStrToDate(NSString* str)
{
    //
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];

    NSDate *resDate = [dateFormatter dateFromString:str];
    return resDate;

}

NSString* convertDateToStr(NSDate* date)
{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}


int skfly_system(const char* temp)
{
    return 1;
}

/*
NSString* skfly_getUdid()
{
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	void *gestalt = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY);
	CFStringRef (*MGCopyAnswer)(CFStringRef) = (CFStringRef (*)(CFStringRef))(dlsym(gestalt, "MGCopyAnswer"));
	return CFBridgingRelease(MGCopyAnswer(CFSTR("UniqueDeviceID")));
}
*/

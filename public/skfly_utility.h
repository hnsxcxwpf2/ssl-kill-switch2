//
//  skfly_utility.h
//

#ifndef skfly_utility_h
#define skfly_utility_h

#import <stdio.h>


//重写NSLog,Debug模式下打印日志和当前行数
/**/
#define DEBUG   1

#if DEBUG
#define MyLog(FORMAT, ...)	skfly_write_to_net_http(__FILE__,__LINE__,__FUNCTION__,[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
#define NSLog(FORMAT, ...)    skfly_write_to_net_http(__FILE__,__LINE__,__FUNCTION__,[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
//#define MYLOG(FORMAT, ...) NSLog(@" function:%s line:%d content:%@\n", __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]);
#else
#define MyLog(FORMAT, ...)	nil
#endif

#ifdef __cplusplus
extern "C" {
#endif




extern NSString* g_skfly_phone_name;
extern NSString* g_skfly_udid;
extern NSString* g_skfly_program_name;
extern long long g_skfly_instance_id;

NSString* g_skfly_getNowTimeTimestampMsStr();
long long g_skfly_getNowTimeTimestampMsLong();

int skfly_write_to_net_http(const char* fileName,int lineNo,const char* funcName,NSString *content);
int skfly_write_to_net_http2(const char* fileName,int lineNo,const char* funcName,char *format, ...);

int write_log (const char* filePath,const char *format, ...);

int skfly_write_to_file(NSString* filePath,NSString* content);

int skfly_write_to_net(NSString* content);

NSData* convertHexStrToData(NSString *str);

NSString* convertDataToHexStr(NSData * data);

NSDate* convertStrToDate(NSString* str);

NSString* convertDateToStr(NSDate* date);

NSString* skfly_getUdid();

#ifdef __cplusplus
}
#endif





#endif /* skfly_utility_h */

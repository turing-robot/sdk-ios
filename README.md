
# 图灵语音、语义SDK iOS版开放接口参考手册		##功能介绍####接口基本信息#####兼容性###- 系统:支持 iOS 5.0 及以上系统；- 架构:armv7、armv7s、arm64、i386、x86_64；- 机型:iPhone 4+,iPad 2+和 iPod 5+；- 硬件要求:需要有麦克风,用于支持语音录入。 网络:支持 NET、Wifi 网络环境。  ###开发包说明 ###

文件名称 | 用途 
--- | --- 
TRRTuringAPI.h	 | 图灵SDK API的通用头文件TRRTuringAPIConfig.h | 图灵SDK API的配置工具类头文件TRRTuringRequestManager.h | 图灵SDK API的请求管理器头文件TRRVoiceRecognitionManager.h | 图灵SDK的语音识别管理器头文件TRRSpeechSythesizer.h |	图灵SDK的语音合成管理器头文件BDVoiceRecognitionClient.h	 | 百度语音识别功能头文件libTuringSDK.a	| 图灵SDK的静态链接库文件Localizable.strings | 语音识别接口的字符本地化文件（中文简体）###集成准备###
1.	使用条件
	使用图灵开放API SDK，需要注册图灵API开发者账号，并获得API Key。详见 http://www.tuling123.com/openapi/	由于图灵语音识别和语音合成接口底层会调用Baidu相关接口。因此使用图灵SDK，需要开发者提前获取Baidu开发者账号，并创建应用，获得AppID、API Key、Secret Key。具体请参考http://yuyin.baidu.com/ 2.	框架依赖
	以下是本SDK可能用到的Framework，部分依赖关系来自于Baidu SDK。	- SystemConfiguration.framework	- Foundation.framework	- AVFoundation.framework	- GLKit.framework	- OpenGLES.framework	- libz.1.dylib	- Security.framework
	- CFNetwork.framework	- CoreLocation.framework3.	第三方库
	图灵SDK依赖以下第三方库（SDK包中已提供，请集成到应用工程中）	- OpenUDID	- JSONKit、	- TTTAttributedLabel	- CoreAudioUtility(苹果Audio库)
	对于采用ARC内存管理方式的工程，需要利用Non-ARC方式表姨OpenUDID和JSONKit（对相应文件添加Compiler Flags为-fno-objc-arc）4.	其他集成准备事项
	因为SDK包中采用Objective C++实现，因此需要保证工程中引用静态库头文件的实现文件的扩展名必须为.mm。 
5. iOS 9适配事项
	（1）HTTP访问
	iOS9系统默认使用HTTPS网络协议。由于百度和图灵SDK目前都只采用HTTP协议，因此基于图灵SDK的应用程序也要允许HTTP访问。
		<key>NSAppTransportSecurity</key>
    	<dict>
        	<key>NSAllowsArbitraryLoads</key>
       		<true/>
    	</dict>
	（2）BITCODE问题
	由于底层的百度SDK编译时采用ENABLE_BITCODE模式，因此基于图灵SDK的应用程序也不能采用ENABLE_BITCODE模式。##API使用指南#####语义分析#######获取语义分析设置对象####图灵API使用需要**API Key**（从图灵SDK网站申请）和**UserID**（由SDK根据用户信息生成）。TRRTuringAPIConfig类会协助用户获得这两个属性，用来完成图灵API的设置
1. 利用图灵API Key初始化TRRTuringAPIConfig对象。
		- (instancetype)initWithAPIKey:(NSString *)apikey;2. 该初始化过程中，SDK将读取本地是否缓存了UserID信息。用户可以检查TRRTuringAPIConfig对象的UserID属性，如UserID等于nil，用户需要调用以下接口，联网获取UserID		- (void)request_UserIDwithSuccessBlock:(SuccessStringBlock)success failBlock:(FailBlock)failed;	由于联网获取UserID是异步操作，用户可以通过设置参数**success**和**failed**两个Block，来处理操作成功和失败场景。
	其中success Block的参数是成功获得的UserID，failed Block的参数是API失败类型，或相关信息字符串。	
####使用语义分析接口####1.	首先要获得TRRTuringAPIConfig对象，并用该对象完成语义分析接口的设置；
		- (instancetype)initWithConfig:(TRRTuringAPIConfig *)config;
2. 调用语义分析接口
		- (void)request_OpenAPIWithInfo:(NSString *)info successBlock:(SuccessDictBlock)success failBlock:(FailBlock)failed;	由于语义分析接口是异步操作，用户可以通过设置参数**success**和**failed**两个Block，来处理操作成功和失败场景。
	其中success Block的参数是语义分析接口返回的JSON数据转换成的Dictionary类型，failed Block的参数是API失败类型，或相关信息字符串。	
	代码示例如下
		//初始化TRRTuringAPIConfig对象
		TRRTuringAPIConfig *apiConfig ＝ [[TRRTuringAPIConfig alloc]initWithAPIKey:@"TuringApiKey"];
		TRRTuringRequestManager apiRequest = [[TRRTuringRequestManager alloc] initWithConfig:apiConfig];
		//如userID==nil,需要调用request_UserIDwithSuccessBlock:failBlock:接口获取UserID
		if (apiConfig.userID == nil) {	    	[apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {	    		//获取UserID成功，继续调用OpenAPI接口
        		[apiRequest request_OpenAPIWithInfo:self.inputTextView.text 						successBlock:^(NSDictionary *dict) {
        			    	//处理语义分析接口的返回结果
            				_outputTextView.text = [dict objectForKey:@"text"];
        				} failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
        				    //处理语义分析失败结果
			           		 _outputTextView.text = infoStr;
        		}];
    		}
    		failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
    			//处理获取UserID失败的场景
        		_outputTextView.text = infoStr;
        		NSLog(@"erroresult = %@", infoStr);
            }];
        } else {
        	//如本地缓存了UserID，则直接调用OpenAPI接口
        	[apiRequest request_OpenAPIWithInfo:self.inputTextView.text 						successBlock:^(NSDictionary *dict) {
            				NSLog(@"apiResult =%@",dict);
            				_outputTextView.text = [dict objectForKey:@"text"];
        				} failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
           		 _outputTextView.text = infoStr;
            	NSLog(@"errorinfo = %@", infoStr);
        		}];
        }
                        
                                    	###语音合成###
图灵语音合成API底层会调用Baidu语音合成API，因此使用图灵SDK时需要获得Baidu语音合成API所需的**API Key**和**Secret Key**。

####初始化语音合成对象####
初始化语音合成对象，并设置API Key和Secret Key。


		- (instancetype)initWithAPIKey:(NSString *)apikey secretKey:(NSString *)secretkey;
####设置语音合成参数####
通过以下接口设置语音合成参数，参数Key-Value取值参考Baidu SDK中的BDSSpeechSynthesizer.h文件

		- (int)setParamForKey:(NSString *)key value:(NSString *)value;
如果不进行参数设置，图灵SDK将采用默认的参数进行语音合成，默认参数如下

- 文本编码，默认编码类型为UTF8;
- 发音人，默认为女声；
- 发音音量、语速、音调采取［0-9］的中间值5；
- 音频格式，默认为amr
- 音频比特率，默认为15.85k比特率

####控制语音合成操作####
利用以下接口可以完成语音合成操作的开始、暂停、恢复、停止等操作。除停止操作外，其他三个操作都会返回int类型的返回值，其错误值含义请参考BDSSpeechSynthesizer.h文件

		- (int)start:(NSString *)text;
		- (int)pause;
		- (int)resume;
		- (void)stop;

	
	###语音识别###
图灵语音识别API底层会调用Baidu语音识别API，因此使用图灵SDK时需要获得Baidu语音识别API所需的**API Key**和**Secret Key**。


####获取语音识别单例句柄####
语音识别结果为单例实现，在使用过程中可以调用以下接口获得单例句柄：

		+ (TRRVoiceRecognitionManager *)sharedInstance;
####设置语音识别API Key和Secret Key####

		- (void)setApiKey:(NSString *)apiKey secretKey:(NSString *)secretKey;


####控制语音识别操作####
通过以下接口可以完成对语音识别操作的启动、关闭和取消功能

		//启动语音识别操作, 返回值参考BDVoiceRecognitionClient.h中TVoiceRecognitionStartWorkResult
		- (int)startVoiceRecognition;

		//停止语音识别操作，代表手动触发用户发音结束事件
		- (void)stopRecognize;

		//取消正在进行的语音识别操作
		- (void)cancleRecognize;				


####通过Delegate接收语音识别结果####

通过实现TRRVoiceRecognitionManagerDelegate协议，应用程序可以接收语音识别的结果信息，包括正确的结果信息和发生错误时的错误信息。通过实现TRRVoiceRecognitionManagerDelegate协议，开发人员可以捕获识别引擎开始工作，检测到用户已说话，检测到用户已停止说话等事件。

	@protocol TRRVoiceRecognitionManagerDelegate <MVoiceRecognitionClientDelegate>
		//接收语音识别结果的代理函数
		- (void)onRecognitionResult:(NSString *)result;
		//接收语音识别错误信息的代理函数。
		- (void)onRecognitionError:(NSString *)errStr;
		//已启动语音识别的事件处理函数。
		- (void)onStartRecognize;
		//检测到用户已说话的事件处理函数。
		- (void)onSpeechStart;
		//检测到用户已停止说话的事件代理函数。
		- (void)onSpeechEnd;
	@end

开发人员需要操作TRRVoiceRecognitionManager对象的属性delegate来设置代理

	@property (nonatomic, weak) id <TRRVoiceRecognitionManagerDelegate> delegate;

####设置语音识别参数####

		//获取采样速率信息
		- (int)getCurrentSampleRate;

		// 获取当前音量级别
		- (int)getCurrentDBLevelMeter;

		//当前识别类型数组，参见BDVoiceRecognitionClient.h
		@property (nonatomic, strong) NSArray *recognitionPropertyList;

		//设置城市信息
		- (void)setCityID: (NSInteger)cityID;

		//进行功能设置，具体参数及取值参考BDVoiceRecognitionClient.h
		- (void)setConfig:(NSString *)key withFlag:(BOOL)flag;

		//设置识别语言，具体参数及取值参考BDVoiceRecognitionClient.h
		- (void)setLanguage:(int)language;

		//关闭标点
		- (void)disablePuncs:(BOOL)flag;

		//设置是否需要对录音数据进行端点检测
		- (void)setNeedVadFlag: (BOOL)flag;

		// 设置是否需要对录音数据进行压缩
		- (void)setNeedCompressFlag: (BOOL)flag;
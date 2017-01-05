
# 图灵语音、语义SDK iOS版开放接口参考手册

文件名称 | 用途 
--- | --- 
TRRTuringAPI.h	 | 图灵SDK API的通用头文件



	- CFNetwork.framework







    	<dict>
        	<key>NSAllowsArbitraryLoads</key>
       		<true/>
    	</dict>




	其中success Block的参数是成功获得的UserID，failed Block的参数是API失败类型，或相关信息字符串。


2. 调用语义分析接口
		- (void)request_OpenAPIWithInfo:(NSString *)info successBlock:(SuccessDictBlock)success failBlock:(FailBlock)failed;
	其中success Block的参数是语义分析接口返回的JSON数据转换成的Dictionary类型，failed Block的参数是API失败类型，或相关信息字符串。


		TRRTuringAPIConfig *apiConfig ＝ [[TRRTuringAPIConfig alloc]initWithAPIKey:@"TuringApiKey"];
		TRRTuringRequestManager apiRequest = [[TRRTuringRequestManager alloc] initWithConfig:apiConfig];
		//如userID==nil,需要调用request_UserIDwithSuccessBlock:failBlock:接口获取UserID
		if (apiConfig.userID == nil) {
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
--打印日志
session:consoleLog("info","----into lua ---");
session:answer();
--设置这一行才会在lua执行完毕之后不自动挂断
session:setAutoHangup(false);

--一定要判断当前会话还有没有效
while (session:ready() == true) do
        --播放语音拨号音
	prompt = "tone_stream://%(60000,0,350,440)"
	result = ""
	digits_received = ""
        
	extn = session:playAndGetDigits(1, 12, 5, 20000, "#", prompt, "", "\\d+", digits_received, 5000, "")
	session:execute("log", "INFO extn=" .. extn)

	if (extn == nil or  extn == "" ) then
       		session:execute("log", "ERR  dtmf is null:" .. extn)
	elseif ( string.len(extn) == 4 ) then
		session:execute("bridge", "user/" .. extn)
	else
		--closed by TeleCom Operator
		arg = "sofia/external/" .. extn .. "@192.168.1.9"
	        session:execute("log", "INFO arg=" .. arg)
		--api = freeswitch.API()
		--result = session:execute("transfer", arg)
		--result = session:transfer(extn, "XML", "default");
	end

        --freeswitch.consoleLog("WARNING","session is not ready\n")
end

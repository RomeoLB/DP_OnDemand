'22/05/24 - RLB - Plugin parse Dynamic playlist and extract filename for retrieving key for ON Demand state

'OnDemandKey - plugin name

Function OnDemandKey_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

   ' print "OnDemandKey_Initialize - entry"
   ' print "type of msgPort is ";type(msgPort)
    'print "type of userVariables is ";type(userVariables)

    OnDemandKey = newOnDemandKey(msgPort, userVariables, bsp)
	
    return OnDemandKey
End Function



Function newOnDemandKey(msgPort As Object, userVariables As Object, bsp as Object)
	
	print "initOnDemandKey Plugin"

	' Create the object to return and set it up
	
	s = {}
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = OnDemandKey_ProcessEvent
	s.PluginSendMessage = PluginSendMessage
	s.PluginSendZonemessage = PluginSendZonemessage
	s.sTime = createObject("roSystemTime")		
	s.HandleTimerEventPlugin = HandleTimerEventPlugin
	s.HandlePluginUDPEvent = HandlePluginUDPEvent
	s.HandlePluginMessageEvent = HandlePluginMessageEvent
	s.StartIndexedSequenceTimer = StartIndexedSequenceTimer
	s.CheckFeed = CheckFeed
	s.PluginSystemLog = CreateObject("roSystemLog")
	s.PluginSystemLog.SendLine(" @@@ Plugin Version 1.0 for retrieving keys for ON Demand Playback @@@ ")
	s.FunctionSequenceOrderAr = [["CheckFeed",2000]]
	s.FunctionListIndex = 0
	s.StartIndexedSequenceTimer(s.FunctionSequenceOrderAr[s.FunctionListIndex][0], s.FunctionSequenceOrderAr[s.FunctionListIndex][1])

	return s
End Function


	
Function OnDemandKey_ProcessEvent(event As Object) as boolean

	retval = false
    'print "OnDemandKey_ProcessEvent - entry"
   ' print "type of m is ";type(m)
   ' print "type of event is ";type(event)

	if type(event) = "roControlDown" then
			
		'retval = HandlePluginGPIOEvent(event, m)
	
	else if type(event) = "roAssociativeArray" then
		
		if type(event["EventType"]) = "roString"
			' print ""
			' print " @@@ EventType @@@ "; event["EventType"]
			' print ""
			if event["EventType"] = "EVENT_PLUGIN_MESSAGE" then
				if event["PluginName"] = "OnDemandKey" then
					pluginMessage$ = event["PluginMessage"]	
					'retval = HandlePluginMessageEvent(pluginMessage$)
				end if
			
			else if event["EventType"] = "SEND_PLUGIN_MESSAGE" then
			
				if event["PluginName"] = "OnDemandKey" then
					pluginMessage$ = event["PluginMessage"]
					m.HandlePluginMessageEvent(pluginMessage$)
				end if
				
			else if event["EventType"] = "USER_VARIABLES_UPDATED" then
				'stop
			else if event["EventType"] = "USER_VARIABLE_CHANGE" then

			end if
		end if
	else if type(event) = "roDatagramEvent" then
	
		retval = HandlePluginUDPEvent(event, m)
	else if type(event) = "roTimerEvent" then
	
		retval = HandleTimerEventPlugin(event, m)	
	else if type(event) = "roVideoEvent" then
	
		retval = HandlePluginVideoEvent(event, m)
	else if type(event) = "roAssetFetcherEvent" then
	
		'retval = HandlePluginroAssetFetcherEvent(event, m)
	else if type(event) = "roHtmlWidgetEvent" then
	
		'retval = HandleHtmlWidgetEventPlugin(event, m)
	else if type(event) = "roStreamByteEvent" then

		'retval = HandleStreamByteEventPlugin(event, m)	
	else if type(event) = "roStreamLineEvent" then	

		'retval = HandleStreamEventPlugin(event, m)
	end if
	
	return retval
End Function
	


Function HandlePluginUDPEvent(origMsg as Object, m as Object) as boolean

	print "UDP Message Received in plugin - "; origMsg
End Function



Function HandleTimerEventPlugin(origMsg as Object, m as Object) as boolean

	timerIdentity = origMsg.GetSourceIdentity()
			
	if type(m.IndexedSequenceTimer) = "roTimer" then
		
		if m.IndexedSequenceTimer.GetIdentity() = origMsg.GetSourceIdentity() then

			userData = origMsg.GetUserData()
			'print "FunctionName: "; userData.FunctionName
			'print "TimeoutVal: ";  userData.TimeoutVal
			FunctionName = userData.FunctionName

			if FunctionName = "CheckFeed" then
				m.CheckFeed()			  
			end if  

			' if FunctionName = "BacktoLoop" then
			' 	m.BacktoLoop()			  
			' end if  

			if m.FunctionListIndex < m.FunctionSequenceOrderAr.count() - 1 then
				m.FunctionListIndex = m.FunctionListIndex + 1
				m.StartIndexedSequenceTimer(m.FunctionSequenceOrderAr[m.FunctionListIndex][0], m.FunctionSequenceOrderAr[m.FunctionListIndex][1])
			end if 
			
			return true
		end if
	end if
End Function
	


Function HandlePluginMessageEvent(origMsg as string)

	print ""
	print " @@@ HandlePluginMessageEvent: "; origMsg
	print ""

	if origMsg = "GenNum" then
		'm.GenerateAllSessionSets()
	end if 	
End Function



Function PluginSendMessage(Pmessage$ As String)

	pluginMessageCmd = CreateObject("roAssociativeArray")
	pluginMessageCmd["EventType"] = "EVENT_PLUGIN_MESSAGE"
	pluginMessageCmd["PluginName"] = "OnDemandKey"
	pluginMessageCmd["PluginMessage"] = Pmessage$
	m.msgPort.PostMessage(pluginMessageCmd)
End Function


Sub PluginSendZonemessage(msg$ as String)
	' send ZoneMessage message
	zoneMessageCmd = CreateObject("roAssociativeArray")
	zoneMessageCmd["EventType"] = "SEND_ZONE_MESSAGE"
	zoneMessageCmd["EventParameter"] = msg$
	m.msgPort.PostMessage(zoneMessageCmd)
End Sub



Function HandlePluginVideoEvent(origMsg as Object, m as object) as boolean

	print " HandleVideoEventPlugin "; origMsg

	retval = false

	VideoPlayerEventReceived = origMsg.GetInt()

	print "VideoPlayerEventReceived: "; VideoPlayerEventReceived

	if VideoPlayerEventReceived = 8 then 
	
		VideoSourceIdentity = origMsg.GetSourceIdentity()
		VideoSourceIdentity$ = VideoSourceIdentity.toStr()

		print "Video Ended on: "; m.bsp.sign.zoneshsm[0].activestate.name$  	
	else if VideoPlayerEventReceived = 3 then 	 
		
		print "Video Started : " 

	else if VideoPlayerEventReceived = 16 then
		
		print "Video MediaError : " 
	end if

	return retval
End Function



Function StartIndexedSequenceTimer(FunctionName as String, TimeoutVal as integer)
    userdata = {}
    userdata.FunctionName = FunctionName
    userdata.TimeoutVal = TimeoutVal

    newTimeout = m.sTime.GetLocalDateTime()
    newTimeout.AddMilliseconds(TimeoutVal)
    m.IndexedSequenceTimer = CreateObject("roTimer")
    m.IndexedSequenceTimer.SetPort(m.msgPort)	
    m.IndexedSequenceTimer.SetDateTime(newTimeout)
    m.IndexedSequenceTimer.SetUserData(userdata)	
    ok = m.IndexedSequenceTimer.Start()
End Function


Function CheckFeed()

	path = "sd:/feed_cache/"
	UserVarStringKey = ""

	l=ListDir(path)
	for each item in l
		print ""
		xmlFileName$ = path + item
		print "xmlFileName$: "; xmlFileName$

		xml = CreateObject("roXMLElement")

		if not xml.Parse(ReadAsciiFile(xmlFileName$)) then 
			print "xml read failed"	
		else
	
			itemsByTitle = []

			if type(xml.channel.title) = "roXMLList" then
	
				if type(xml.channel.item) = "roXMLList" then
				
					ItemIndex% = 0

					for each itemXML in xml.channel.item

						title = xml.channel.item[ItemIndex%].title.gettext()
						print " Title  -   " title
						UserVarStringKey = UserVarStringKey + ":" + title
						itemsByTitle.push(title)
						
						ItemIndex% = ItemIndex% + 1
					next
					
					formattedUserVarStringKey = Right(UserVarStringKey,(len(UserVarStringKey)-1))

					print""
					print "formattedUserVarStringKey: "; formattedUserVarStringKey
					print "" 

					if m.bsp.currentuservariables.OnDemandKeys <> invalid then
						m.bsp.currentuservariables.OnDemandKeys.setcurrentvalue(formattedUserVarStringKey, true)
						m.PluginSystemLog.sendline(" @@@ User Variable set for formattedUserVarStringKey: " + formattedUserVarStringKey)
					end if
				end if		
			end if
	
			' print Chr(13) + Chr(10)
			
			' print ""
			' print" @@@ itemsByTitle @@@ " Chr(13) + Chr(10) 
			' print itemsByTitle
			' print ""
		end if    
	next
End Function


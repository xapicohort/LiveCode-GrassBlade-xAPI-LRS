﻿script "Video Player Behavior script"
Local sSegmentStartTime, sSegmentEndtime, sPlayedSegments, sSessionID, sDurationStartTime
local sVideoLength, sCompletionThreshold
on opencard
   put empty into field "video URL" of me
   put empty into field "results"
   put empty into field "xAPI Statement"
   put empty into field "Simple Statement Display"
   set the filename of player "Video Object Player" of me to empty
   set the label of of Button "Open/Close Video"  to "Open Video"
   put empty into field "video name" of me
   focus on field "video name" of me
end opencard

on mouseUp
   if the short name of the target is the short name of this card then exit mouseUp
   put the short name of the target
   switch the short name of the target
      case "close Instructions"
         hide group "Instructions"
         --         hide field "Instructions" of me
         --         hide widget "close Instructions" of me
         --         hide field "Instructions label" of me
         break
      case "show Instructions"
         show group "Instructions"
         --         show field "Instructions" of me
         --         show widget "close Instructions" of me
         --         show field "Instructions label" of me
         break
      case "Open/Close Video"
         switch the label of the target
            case "Open Video"
               openVideo
               set the label of the target to "Close Video"
               break
            case "Close Video"
               closeVideo
               set the label of the target to "Open Video"
               break
         end switch
         break
      case "Home"
         go to first card
         break
      case "Video Object Player"
         if the mouseloc is within the rect of graphic "Player Scrubber Rect" then
            ## BUG:  If the mouse is released outside of the player controller rect this will not work.
            ## need to handle this.
            set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
            seekedInVideo the cVideoTimeStart of this stack, the cVideoTimeStop of this stack
         end if
         break
   end switch
end mouseUp

on mouseDown
   if the short name of the target is the short name of this card then exit mouseDown
   switch the short name of the target
      case "Video Object Player"
         get the cVideoTimeStop of this stack 
         set the cVideoTimeStart of this stack to it
         break
   end switch
end mouseDown

command OpenVideo
   # this is mapped to the xAPI command initialized
   switch the platform
      case "MacOS"
         put "Quicktime Video files|mov,mp4,m4v|MooV,mpg4" into tAcceptedVideoTypes
         break
      case "Win32"
      case "Win64"
         put "Windows Media Video files|wmv" into tAcceptedVideoTypes
         break
   end switch
   answer file "Select a video." with type tAcceptedVideoTypes
   # Update the user interface
   put it into field "video URL"
   set the filename of player "Video Object Player" of me to field "video URL" of me
   put empty into sSegmentStartTime
   put empty into sSegmentEndtime
   put empty into sPlayedSegments
   
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   put the duration of player "Video Object Player" of me into tVideoDuration
   put the timescale of player "Video Object Player" of me into tVideoTimeScale
   
   # context > extensions > session-id
   put uuid("random") into sSessionID
   put sSessionID into tContextA["extensions"]["session-id"]
   ## context > extensions > length
   put convertToxAPITimeFormat(tVideoDuration, tVideoTimeScale) into sVideoLength
   put sVideoLength into tContextA["extensions"]["length"]
   ## context > extensions > completion-threshold
   put field "Completion threshold" of me into tCompletionThreshold
   if tCompletionThreshold is empty then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold is not a number then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold > 100 or tCompletionThreshold < 0 then
      put 100 into field "Completion Threshold"
   end if
   put field "Completion threshold" of me / 100 into sCompletionThreshold
   put sCompletionThreshold into tContextA["extensions"]["completion-threshold"]
   
   ## no result for this verb
   put empty into tResultA
   
   ## update UI
   set the label of the target to "Close Video"
   
   # JOAN: add actor information
   addxAPIActor field "username" of card 1 of this stack, field "user email" of card 1 of this stack
   # JOAN: add object information
   addxAPIObject field "video URL", "Activity", field "video name" of me, "en-US", "A Headset that reads your brainwaves", "en-US", "Activity"
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/initialized", "initialized", tResultA, tContextA
   # Create and send the xAPI statement
   createxAPIstatement
   sendxAPIstatement
end OpenVideo

command closeVideo
   # this is mapped to the xAPI verb terminated
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   set the filename of player "Video Object Player" of me to empty
   
   ## context > extensions > length
   put sVideoLength into tContextA["extensions"]["length"]
   ## context > extensions > completion-threshold
   put field "Completion threshold" of me into tCompletionThreshold
   if tCompletionThreshold is empty then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold is not a number then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold > 100 or tCompletionThreshold < 0 then
      put 100 into field "Completion Threshold"
   end if
   put field "Completion threshold" of me / 100 into sCompletionThreshold
   put sCompletionThreshold into tContextA["extensions"]["completion-threshold"]
   
   ## result > extensions > time
   put convertToxAPITimeFormat(tPlayerCurrentTime, tPlayerTimeScale) into tTime
   put tTime into tResultA["extensions"]["time"]
   ## result > extensions > progress
   ## The calculation for progress  is simplified and does not account 
   ## for segments skipped yet.
   put round (tTime/ sVideoLength,2) into tProgress
   put tProgress into tResultA["extensions"]["progress"]
   ## result > extensions > played-segments
   put getPlayedSegments() into tResultA["extensions"]["played-segments"]
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/terminated", "terminated", tResultA, tContextA
   createxAPIstatement
   sendxAPIstatement
   
   ## Upate UI
   put empty into field "video URL"
   put empty into field "Simple Statement Display"
   ## TODO:  Add command to empty the object
   --clearxAPIVerb
end closeVideo

on playstarted
   ## this player object message is mapped to the xAPI command played
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStart of this stack to the currenttime of player "Video Object Player" of me
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   put convertToxAPITimeFormat(tPlayerCurrentTime, tPlayerTimeScale) into tTime
   
   ## context > extensions > session-id
   put uuid("random") into sSessionID
   put sSessionID into tContextA["extensions"]["session-id"]
   ## context > extensions > length
   put sVideoLength into tContextA["extensions"]["length"]
   ## completed > result > duration
   ## this enters start time value to calulate duration in completed handler
   put the seconds into sDurationStartTime
   
   ## result > extensions > time
   put tTime into tResultA["extensions"]["time"]
   ## result > extensions > played-segments
   addSegmentStartTime tTime
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/played", "played", tResultA, tContextA
   createxAPIstatement
   sendxAPIstatement
end playstarted

on playPaused
   ## this player object message is mapped to the xAPI command paused
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   
   # context > extensions > session-id
   put uuid("random") into sSessionID
   put sSessionID into tContextA["extensions"]["session-id"]
   ## context > extensions > length
   put sVideoLength into tContextA["extensions"]["length"]
   ## context > extensions > completion-threshold
   put field "Completion threshold" of me into tCompletionThreshold
   if tCompletionThreshold is empty then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold is not a number then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold > 100 or tCompletionThreshold < 0 then
      put 100 into field "Completion Threshold"
   end if
   put field "Completion threshold" of me / 100 into sCompletionThreshold
   put sCompletionThreshold into tContextA["extensions"]["completion-threshold"]
   
   ## result > extensions > time
   put convertToxAPITimeFormat(tPlayerCurrentTime, tPlayerTimeScale) into tTime
   put tTime into tResultA["extensions"]["time"]
   ## result > extensions > progress
   ## The calculation for progress  is simplified and does not account 
   ## for segments skipped yet.
   put round (tTime/ sVideoLength,2) into tProgress
   put tProgress into tResultA["extensions"]["progress"]
   ## Result > extensions > played-segments
   addSegmentEndTime tTime
   put getPlayedSegments() into tResultA["extensions"]["played-segments"]
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/paused", "paused", tResultA, tContextA
   createxAPIstatement
   sendxAPIstatement
end playPaused

on seekedInVideo pStartTime, pEndTime
   ## this player object message is mapped to the xAPI command seeked in video
   
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   
   # context > extensions > session-ID
   put uuid("random") into sSessionID
   put sSessionID into tContextA["extensions"]["session-id"]
   
   # result > extensions > time-from
   put convertToxAPITimeFormat(pStartTime, tPlayerTimeScale) into tStartTimeConverted
   put tStartTimeConverted into tResultA["result"]["extensions"]["time-from"]
   # result > extensions > time-to
   put convertToxAPITimeFormat(pEndTime, tPlayerTimeScale) into tEndTimeConverted
   put tEndTimeConverted into tResultA["result"]["extensions"]["time-to"]
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/seeked", "seeked", tResultA, tContextA
   createxAPIstatement
   sendxAPIstatement
end seekedInVideo

on playStopped   
   ## this player object message is mapped to the xAPI command completed
   ## this will be triggered when the video reaches the endTime set in the player properties
   ## or startTime if playing in reverse.
   ## If the endTime = the video duration or = 0 it will be triggered when the full movie plays.
   
   ## BUG:
   ## If there is a selection in the video and the endTime < the video Duration this will be likely be called
   ## when the video reaches the value of endTime of the selection so have to handle this exception
   
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
   
   ## context > extensions > length
   put sVideoLength into tContextA["extensions"]["length"]
   ## context > extensions > completion-threshold
   put field "Completion threshold" of me into tCompletionThreshold
   if tCompletionThreshold is empty then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold is not a number then
      put 100 into field "Completion Threshold"
   end if
   if tCompletionThreshold > 100 or tCompletionThreshold < 0 then
      put 100 into field "Completion Threshold"
   end if
   put field "Completion threshold" of me / 100 into sCompletionThreshold
   put sCompletionThreshold into tContextA["extensions"]["completion-threshold"]
   
   ## result > Duration
   put "PT" & (the seconds - sDurationStartTime) & "S" into tDuration
   put tDuration into tResultA["duration"]
   ## result > completed
   put "true" into tResultA["completed"]
   ## result > extensions > time
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   put convertToxAPITimeFormat(tPlayerCurrentTime, tPlayerTimeScale) into tTime
   put tTime into tResultA["extensions"]["time"]
   ## result > extensions > progress
   ## BUG:
   ## The calculation for progress  is simplified and does not account 
   ## for segments skipped yet.
   ## result > extensions > progress
   put round (tTime/ sVideoLength,2) into tProgress
   put tProgress into tResultA["extensions"]["progress"]
   ## result > extensions > played-segments
   addSegmentEndTime tTime
   put getPlayedSegments() into tResultA["extensions"]["played-segments"]
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/completed", "completed", tResultA, tContextA
   createxAPIstatement
   sendxAPIstatement
end playStopped

command screenChangeInteraction   
   ## this is mapped to the xAPI verb interacted
   ## TODO:  This in not implemented yet. 
   ## - Need the code to intercept the message when the video enters and exits full screen
   
   ## get data for setting result and/or context
   set the cISO8601TimeStamp of this stack to the milliseconds
   
   addxAPIVerb "http://adlnet.gov/expapi/verbs/interacted", "interacted"
   createxAPIstatement
   sendxAPIstatement
end screenChangeInteraction

on addSegmentStartTime tTime
   ## this for getting data for setting result > extensions > played-segments
   if sPlayedSegments is empty then
      put tTime & "[.]" into sPlayedSegments
   else
      put "[,]" & tTime & "[.]" after sPlayedSegments
   end if
end addSegmentStartTime

on addSegmentEndTime tTime
   ## this for getting data for setting result > extensions > played-segments
   put tTime after sPlayedSegments
end addSegmentEndTime tTime

function getPlayedSegments
   ## this for returning data for setting result > extensions > played-segments
   return sPlayedSegments
end getPlayedSegments






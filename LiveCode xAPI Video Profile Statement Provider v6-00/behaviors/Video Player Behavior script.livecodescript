script "Video Player Behavior script"
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
   set the cISO8601TimeStamp of this stack to the milliseconds
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
   set the label of the target to "Close Video"
   # Create and send the xAPI statement
   # JOAN: add actor information
   addxAPIActor field "username" of card 1 of this stack, field "user email" of card 1 of this stack
   addxAPIObject field "video URL", "Activity", field "video name" of me, "en-US", "A Headset that reads your brainwaves", "en-US", "Activity" 
   addxAPIVerb "http://adlnet.gov/expapi/verbs/initialized", "initialized"
   createxAPIstatement
   sendxAPIstatement
end OpenVideo

command closeVideo
   # this is mapped to the xAPI verb terminated
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the filename of player "Video Object Player" of me to empty
   addxAPIVerb "http://adlnet.gov/expapi/verbs/terminated", "terminated"
   createxAPIstatement
   sendxAPIstatement
   ## BUG in Grassblade LRS activity stream this verb is shown as the verb ""completed
   put empty into field "video URL"
   put empty into field "Simple Statement Display"
   ## TODO:  Add command to empty the object
   --clearxAPIVerb
end closeVideo

on playstarted
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStart of this stack to the currenttime of player "Video Object Player" of me
   # this player object message is mapped to the xAPI command played
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   put convertToxAPITimeFormat(tPlayerCurrentTime, tPlayerTimeScale) into tTime
   put tTime into tResultA["extensions"]["time"]
   addxAPIVerb "http://adlnet.gov/expapi/verbs/played", "played", tResultA
   createxAPIstatement
   sendxAPIstatement
end playstarted

on playPaused
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
   # this player object message is mapped to the xAPI command paused
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   put convertToxAPITimeFormat(tPlayerCurrentTime, tPlayerTimeScale) into tTime
   put tTime into tResultA["extensions"]["time"]
   addxAPIVerb "http://adlnet.gov/expapi/verbs/paused", "paused", tResultA
   createxAPIstatement
   sendxAPIstatement
end playPaused

on seekedInVideo pStartTime, pEndTime
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
   # this player object message is mapped to the xAPI command paused
   put the timescale of player "Video Object Player" of me into tPlayerTimeScale
   put the currenttime of player "Video Object Player" of me into tPlayerCurrentTime
   put convertToxAPITimeFormat(pStartTime, tPlayerTimeScale) into tStartTimeConverted
   put tStartTimeConverted into tResultA["result"]["extensions"]["time-from"]
   put convertToxAPITimeFormat(pEndTime, tPlayerTimeScale) into tEndTimeConverted
   put tEndTimeConverted into tResultA["result"]["extensions"]["time-to"]
   addxAPIVerb "http://adlnet.gov/expapi/verbs/seeked", "seeked", tResultA
   createxAPIstatement
   sendxAPIstatement
end seekedInVideo

on playStopped
   set the cISO8601TimeStamp of this stack to the milliseconds
   set the cVideoTimeStop of this stack to the currenttime of player "Video Object Player" of me
   # this player object message is mapped to the xAPI command completed
   # this will be triggered when the video reaches the endTime set in the player properties
   # or startTime if playing in reverse.
   # If the endTime = the video duration or = 0 it will be triggered when the full movie plays.
   # If the endTime < the video Duration it will be triggered when the video reaches the value of endTime
   addxAPIVerb "http://adlnet.gov/expapi/verbs/completed", "completed"
   createxAPIstatement
   sendxAPIstatement
end playStopped

command screenChangeInteraction
   set the cISO8601TimeStamp of this stack to the milliseconds
   # this is mapped to the xAPI verb interacted
   ## TODO:  Need the code to intercept the message when the video enters and exits full screen
   addxAPIVerb "http://adlnet.gov/expapi/verbs/interacted", "interacted"
   createxAPIstatement
   sendxAPIstatement
end screenChangeInteraction








# LiveCode-GrassBlade-xAPI-LRS
Martin shared a stack that creates xAPI statement as the user interacts with a video and posts them to an LRS.  He has been working on the stack to create two types of time values needed in xapi statements.  

DETAIL

One is a timestamp which should be added to the statements.   There is a button to the top right of the video player.  For now it just gets the current time and formats it into the ISO 8601 standard needed in xAPI timestamps.  This needs to be turned into a function and put into the stack script.

The other is for the xAPI video library to express time values.  It is already in the stack script at the bottom of the script.   I will upload the version of the stack with these changes.

He added timestamps to the xapi statments. 

Anyone who downloads the project can view the scripting to see the handlers setProp cISO8601TimeStamp and getProp cISO8601TimeStamp and understand how that is done.

The time stamps are set at the card level when each of the actions on the video are performed.

I also have the handler convertToxAPITimeFormat

That is to convert from the current time in a video to the format that is used in the xAPI context and result extensions for the video profile.  I have not added handlers yet to add those extensions but you can see how that is done as well.



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

04-23-21 Martin Updated this project with a version 5: 

GrassBlade xAPI LRS connection-jmd-v5.livecode have been uploaded, also as a zipped file.

Also, he created a video demo for the final xAPI Cohort - Spring 2021 which has been uploaded to YouTube:
https://youtu.be/W6kxAX-JAEw

05-14-21 Update for v6, zipped and source available within the forlder structure: LiveCode xAPI Video Profile Statement Provider v6-00

Video of the v6 demo is in YouTube: https://youtu.be/Aih1aVEnFfU

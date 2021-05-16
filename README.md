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

**04-23-21 Martin Updated this project with a version 5: **

GrassBlade xAPI LRS connection-jmd-v5.livecode have been uploaded, also as a zipped file.

Also, he created a video demo for the final xAPI Cohort - Spring 2021 which has been uploaded to YouTube:
https://youtu.be/W6kxAX-JAEw

05-14-21 Update for v6, zipped and source available within the forlder structure: LiveCode xAPI Video Profile Statement Provider v6-00

Video of the v6 demo is in YouTube: https://youtu.be/Aih1aVEnFfU

Back ground video on converting LiveCode stack with internal scripts to external scripts for mangement via GitHub: https://youtu.be/JHW-yyVhEeA

This is a video of how Martin created script only stacks to hold the object script that were stored within the  binary stackfile to this point.  The script only stacks are just plain text files that git hub can track changes to so we can see the history of changes, branch, commit, do pull requests etc. that is not possible if the scripts are in the binary stackfile.

**05-16-21 **

**Updated the zipped project file**

I have uploaded an updated zipped project file that you can download if you want to use this without working from git repo.  If you make any improvements please submit back to us and we can incorporate them into this project.

**Changed version numbering**
When we started this project we were handling our versioning by serial numbering our stacks with a 1 digit suffix ie v1, v2.
I am changing the versionning to using the common practice of \[main\].\[minor\].\[revision\].  
Staring with version 6 makes it sound like it is a mature product when actually it is still a work in progreass with more of the video profile commands and extensions to be added.  So current version is 0.6.2 which more accurately reflects that this is on its way to a release version (1.0.0) but is not there yet.


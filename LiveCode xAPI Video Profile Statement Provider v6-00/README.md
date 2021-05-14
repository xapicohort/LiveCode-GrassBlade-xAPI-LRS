**Project Goals**

The goal of this project is to create a Learning Record Provider using LiveCode that can send all of the verbs from the xAPI Video Profile
https://torrancelearning.com/xapi/profiles/tools/flattener/?name=video&version=v1.0.3

To determin the proper formatting for some components of the verbs such as 'duration' I also used this site:
https://liveaspankaj.gitbooks.io/xapi-video-profile/content/statement_data_model.html

The following tutorial has been used as an example to determine how create xAPI statements and then from that understanding we created their equivalents in LiveCode
https://www.devlinpeck.com/tutorials/send-custom-xapi-statements.  

Currently this creates xAPI statements for  the following verbs:
- initialized
- played
- paused
- seeked
- completed
- terminated

It includes the required parameters, results and contexts and some of the recommended results and contexts namely:

     - context > extensions > length
     - context > extensions > session-id
     - context > extensions > completion-threshold
     - result > extensions > progress
     - result > extensions > Played-sesgments

**To prepare to test xAPI statements**
1. Click the 'Grassblade' button in Section 1 to the left to set the LRS credentials
2. Click the 'Login' button in Section 2 to the left to set the Actor credentials
3. Click on the 'Open Video Player' button in section 3 to the left to open a video player
- see further directions on the "Video Player" card.

**To Prepare to view the statements in the Grassblade LRS**
1. Go to https://test.gblrs.com/users/login
2. Enter the demo login credentials
  - Username: demo@nextsoftwaresolutions.com
  - Password: demo
3. In the side bar on the left of the window
  -  Click the "reports" dropdown menu
  -  Click the "Activity stream" dropdown menu
  -  Click the "Activity stream"  menu item
     Here you can see the live stream of the xAPI events received by the LRS.  
     Look for those  that were sent with the username you set here for the Actor.

 I updated the stack with the one that now has its object scripts stored in script only stack behaviors so we can track code changes in git hub.
 
There is a video on the xAPI Cohort team #xAPI-in-LiveCode showing how this conversion was done: "xAPI-in-Livecode - Preparing stack for git version control.mov"
The script only stacks now hold the scripts that were in the two cards and the main stack that were stored within the  binary stackfile.  The script only stacks are just plain text files that git hub can track changes to in so as the project is worked on and updated we can see the history of changes, branch, commit, do pull requests etc. that is not possible if the scripts are in the binary stackfile.

Martin Koob

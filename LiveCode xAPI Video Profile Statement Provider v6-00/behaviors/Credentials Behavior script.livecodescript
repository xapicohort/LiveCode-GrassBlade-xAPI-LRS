script "Credentials Behavior script"
on mouseup
   if the short name of the target is the short name of me then exit mouseUp
   switch the label of the target
      case "Login"
         userLogin
         # I commented this out so the button "login/logout" doesn't change its label
         -- set the label of the target to "Logout"
         break
      case "Logout"
         # right now I am not using this caseto give user an option to logout.
         userLogout
         set the label of the target to "Login"
         break
      case "Grassblade"
         set the text of field "LRS Endpoint" to "https://test.gblrs.com/xAPI/"
         set the text of field "API Username" to "29-0025259fcd60c63"
         set the text of field "API Password" to "df19403a3c9bdbe20babbaa2c"
         set the LRS of this stack to "GrassBlade"
         setLRSCredentials field "LRS Endpoint", field "API Username", field "API Password"
         break
      case "Scorm Cloud"
         set the text of field "LRS Endpoint" to "https://cloud.scorm.com/lrs/K3U5OBHBL3/sandbox/statements/"
         set the text of field "API Username" to "wVTC90ybIQrbFb3qXrU"
         set the text of field "API Password" to "TarfYUFLC676p4mrm5w"
         set the LRS of this stack to "Scorm Cloud"
         setLRSCredentials field "LRS Endpoint", field "API Username", field "API Password"
         break
      case "Manual"
         setLRSCredentials field "LRS Endpoint", field "API Username", field "API Password"
         set the LRS of this stack to "Manual"
         break
      case "Clear LRS"
         set the text of field "LRS Endpoint" to empty
         set the text of field "API Username" to empty
         set the text of field "API Password" to empty
         clearLRSCredentials
         break
      case "Open Video Player"
         go card "Video Player"
         break
      case "Send xAPI statement"
         build_xAPI_Statement
         send_xAPI_Request_to_LRS
         break
   end switch
end mouseup

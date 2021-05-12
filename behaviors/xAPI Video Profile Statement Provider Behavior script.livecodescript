script "xAPI Video Profile Statement Provider Behavior script"
# Below are constant variables 
# * note the 'k' prefix
# The three below contain the LRS endpoint and  the credentials the app uses
# to connect to the LRS.

# If the app is only connecting to one LRS then you can use constants.

constant kAPIEndpoint = "https://test.gblrs.com/xAPI/"
constant kAPIUsername = "29-a84cad798d5777b"
constant kAPIPassword = "58c262a7f3ec044954b47430c"

# Below are the script local variables
# * note the 's' prefix
# Declaring them as local here outside of any handler means
# that they can be used in any handler in this script


# If you want to allow the user to change the credentials use the SetLRS handler and the 
# script local variables below
# If you want to allow the user to change the Application's LRSs  endpoint and credentials then
# use the SetLRS handler and store the variables as these script local variables.

local sxAPIEndPoint, sxAPIUsername, sxAPIPassword, sxAPILRS

# these are for the user's creditials which will be used for the actor component of the xAPI statement

local sUserName, sUserEmail, sUserPassword

# These script local variables are used to contain virtual custom properties

local sxAPIActorA, sxAPIObjectA, sxAPIVerbA, sxAPIStatementA, sxAPIStatementJSON, sTimeStamp

local sVideoTimeStart, sVideoTimeStop

# The next set of handlers are used to set and get the values of the script local variables 
# above as virtual custom properties 
# For more information see the section on virtual custom properties at the following link:
# https://lessons.livecode.com/m/4071/l/13158-what-are-the-alternatives-to-using-global-variables

setProp xAPIEndPoint pValueA
   put pValueA into sxAPIEndPoint
end xAPIEndPoint

getProp xAPIEndPoint
   return sxAPIEndPoint
end xAPIEndPoint

setProp xAPIUsername pValueA
   put pValueA into sxAPIUsername
end xAPIUsername

getProp xAPIUsername
   return sxAPIUsername
end xAPIUsername

setProp xAPIPassword pValueA
   put pValueA into sxAPIPassword
end xAPIPassword

getProp xAPIPassword
   return sxAPIPassword
end xAPIPassword

setProp xAPIActorA pValueA
   put pValueA into sxAPIActorA
end xAPIActorA

getProp xAPIActorA
   return sxAPIActorA
end xAPIActorA

setProp xAPIObjectA pValueA
   put pValueA into sxAPIObjectA
end xAPIObjectA

setProp xAPIVerbA pValueA
   put pValueA into sxAPIVerbA
end xAPIVerbA

getProp xAPIVerbA
   return sxAPIVerbA
end xAPIVerbA

setProp xAPIStatementA pValueA
   put pValueA into sxAPIStatementA
end xAPIStatementA

getProp xAPIStatementA
   return sxAPIStatementA
end xAPIStatementA

setProp xAPIStatementJSON pValueA
   put pValueA into sxAPIStatementJSON
end xAPIStatementJSON

getProp xAPIStatementJSON
   return sxAPIStatementJSON
end xAPIStatementJSON

setProp xAPILRS pValue
   put pValue into sxAPILRS
end xAPILRS

getProp xAPILRS
   return sxAPILRS
end xAPILRS

setProp cISO8601TimeStamp pCurrentTime
   put the internet date into tDate 
   set the itemdelimiter to space
   put the last item of tDate into tTimeZone
   put the  character 1 to 3 of tTimeZone & ":" & character 4 to 5 of tTimeZone into tTimeZone
   set the itemdelimiter to comma
   put pCurrentTime mod 1000 into tThousands
   put trunc(pCurrentTime / 1000) into tTime
   convert tTime to dateitems
   if the length of item 2 of tTime = 1 then put "0" before item 2 of tTime
   if the length of item 3 of tTime = 1 then put "0" before item 3 of tTime
   if the length of item 4 of tTime = 1 then put "0" before item 4 of tTime
   if the length of item 5 of tTime = 1 then put "0" before item 5 of tTime
   if the length of item 6 of tTime = 1 then put "0" before item 6 of tTime
   put item 1 of tTime & "-" & item 2 of tTime & "-" & item 3  of tTime & \
         "T" & item 4 of tTime & ":" & item 5 of tTime & ":" & item 6 of tTime & "." & tThousands & \
         tTimeZone into sTimestamp
end cISO8601TimeStamp

getProp cISO8601TimeStamp
   return sTimestamp
end cISO8601TimeStamp

setProp cVideoTimeStop pTime
   put pTime into sVideoTimeStop
end cVideoTimeStop

getProp cVideoTimeStop 
   return sVideoTimeStop
end cVideoTimeStop

setProp cVideoTimeStart pTime
   put pTime into sVideoTimeStart
end cVideoTimeStart

getProp cVideoTimeStart 
   return sVideoTimeStart
end cVideoTimeStart

command setLRSCredentials pEndPoint, pAPIUsername, pAPIPassword
   set the xAPIEndpoint of me to pEndPoint
   set the xAPIUsername of me to pAPIUsername
   set the xAPIPassword of me to pAPIPassword
end setLRSCredentials

command clearLRSCredentials
   set the xAPIEndpoint of me to empty
   set the xAPIUsername of me to empty
   set the xAPIPassword of me to empty
end clearLRSCredentials

command userLogin
   ## Credential values are saved as a script local variable for this card
   ## So they can be used in the userLoginResult callback
   put field "UserName" of this card of me into sUserName
   put field "User email" of this card of me into sUserEmail
   put field "Password" of this card of me into sUserPassword
   
   ## add code here to send login credentials
   ##  on successful login code will send userLoginResult callback message with pResult parameter
   
   ## for now it send 'userLoginResult "Success"' message.
   userLoginResult "Success"
end userLogin

command userLoginResult pResult
   switch pResult
      case "success"
         addxAPIActor sUserName, sUserEmail
         break
      case "failure"
         answer "login failed"
         exit to top
         break
   end switch
end userLoginResult

command userLogout
   put empty into sUserName
   put empty into sUserEmail
   put empty into sUserPassword
   set the xAPIActorA of me to empty
end userLogout

command createxAPIStatement
   local txAPI_StatementA
   union sxAPIActorA with sxAPIObjectA into txAPI_StatementA
   union txAPI_StatementA with sxAPIVerbA into txAPI_StatementA
   # add timestamp
   put the cISO8601TimeStamp of me into txAPI_StatementA["timestamp"]
   put UUID("random") into txAPI_StatementA["id"]
   set the xAPIStatementA of me to txAPI_StatementA
   put ArrayToJSON(txAPI_StatementA, true, true) into txAPIStatementJSON
   set the xAPIStatementJSON of me to  txAPIStatementJSON
   put the xAPIStatementJSON of me into field "xAPI Statement"
   displaySimplexAPIStatement
end createxAPIStatement

command sendxAPIStatement
   put empty into field "Results"
   
   ## DIAGNOSTIC - this outputs the xAPI statement to the Message box so we can see if it
   ## turns out as we expected
   
   
   # If you will set the LRS credentials using constant variables uncomment the following lines
   # JOAN: I uncommented these lines and changed the variable prefixes from t to tx
   put kAPIUsername into txAPIUsername
   put kAPIPassword into txAPIPassword
   put kAPIEndpoint into txAPIEndpoint
   
   # If you are going to allow the user to set the LRS Endpoint and credentials then
   # uncomment out the following lines to set the LRS credentials using script local variables.  
   # Comment out these following 3 lines if you are going to use the constant variables above
   --   put the xAPIUsername of me into txAPIUsername
   --   put the xAPIPassword of me into txAPIPassword
   --   put the xAPIEndpoint of me into txAPIEndpoint
   
   # Set HTTP Headers
   set the httpHeaders to get_xAPI_Request_Headers (txAPIUsername, txAPIPassword)
   
   # JOAN: In the test verb cards, you use this code:
   #    set the xAPIStatementJSON of this stack to field "xAPI JSON"
   # ...and that sets the property value sxAPIStatementJSON
   # So replace this statement...
   --   put the xAPIStatementJSON of me into txAPIStatementJSON
   # ...with this statement
   put  sxAPIStatementJSON into txAPIStatementJSON
   
   # JOAN ADDED
   if the last char of txAPIEndPoint is not "/" then 
      put "/" after txAPIEndPoint
   end if
   put "statements" after txAPIEndPoint
   # end JOAN
   post txAPIStatementJSON  to url txAPIEndpoint
   
   # POST xAPI statement to LRS and display results
   put "Status: " into tStatus
   if the result is empty then 
      put "success" after tStatus
   else
      put the result after tStatus
   end if
   put "Response:" && it into tResponse
   put tStatus & return & tResponse into field "Results"
   
   
   ## TODO: log the statement if offline to be sent later
   ## TODO: clear out the variables from the last statement sxAPIVerbA, sxAPIStatementA, sxAPIStatementJSON
end sendxAPIStatement

command displaySimplexAPIStatement
   put empty into field "Simple Statement Display"
   wait 60
   put the xAPIStatementA of me into txAPIStatementA
   set the itemdelimiter to ":"
   put the second item of txAPIStatementA["object"]["definition"]["name"] into tObjectDisplayName
   --txAPIStatementA["object"]["definition"]["name"]
   put txAPIStatementA["actor"]["name"] && txAPIStatementA["verb"]["display"] && "video" && \
         tObjectDisplayName & "." into field "Simple Statement Display"
end displaySimplexAPIStatement

function get_xAPI_Request_Headers pAuthUser, pAuthPassword
   ## Create headers to send with the POST command that 
   ##   - include the username and password to get access to the LRS
   ##   - indicate that it is a JSON document that is being POSTed to the LRS
   switch the LRS of this stack
      case "Grassblade"
         put  "Authorization: Basic" && base64Encode(pAuthUser & ":" & pAuthPassword) & return & \
               "Content-Type: application/json" & return \
               into tHTTPHeaders
         break
      case "Scorm Cloud"
         put "Authorization: Basic" && base64Encode(pAuthUser & ":" & pAuthPassword) & return & \
               "Content-Type:" && "application/json" & return & "X-Experience-API-Version: 1.0.0" & return \
               into tHTTPHeaders
         break
   end switch
   return tHTTPHeaders
end get_xAPI_Request_Headers

# The next group of handlers set the various components of the xAPI statement : Actor, Object, Verb
command addxAPIActor pActorName, pActormbox
   # Element components
   put "actor" into tComponent 
   put "Agent" into tObjectType
   # Element data
   put tObjectType into txAPI_Statement_ComponentA[tComponent]["objectType"]
   put "mailto:" & pActormbox into txAPI_Statement_ComponentA[tComponent]["mbox"]
   put pActorName into txAPI_Statement_ComponentA[tComponent]["name"]
   set xAPIActorA of me to txAPI_Statement_ComponentA
end addxAPIActor

command addxAPIObject pObjectID, pObjectType, \
      pDefinition_Name, pDefinition_Name_DisplayLanguage, \
      pDescription, pDescription_DisplayLanguage, \
      pDefinition_type 
   -- two potential other params 
   
   # Element components
   # JOAN: The key "object" is case sensitive.
   put "object" into tComponent
   put "Activity" into tObjectType
   # Element Data
   put pObjectID into txAPI_Statement_ComponentA[tComponent]["id"]
   put pObjectType into txAPI_Statement_ComponentA[tComponent]["type"]
   put pDefinition_Name_DisplayLanguage & ":" && pDefinition_Name into txAPI_Statement_ComponentA[tComponent]["definition"]["name"]
   put pDefinition_DescriptionDisplayLanguage & ":" && pDefinition_Description into txAPI_StatementA[tComponent]["definition"]["description"]
   put pDefinition_type into txAPI_Statement_ComponentA[tComponent]["definition"]["type"]
   set the xAPIObjectA of me to txAPI_Statement_ComponentA
end addxAPIObject

command addxAPIVerb pVerbID, pVerbDisplay, pVerbResultA
   # Element components
   put "verb" into tComponent
   # Element data
   # TODO  change to same process as with actor usisng the following example
   --   put tObjectType into txAPI_Statement_ComponentA[tComponent]["ObjectType"]
   --   put pActormbox into txAPI_Statement_ComponentA[tComponent]["mbox"]
   --   put pActorName into txAPI_Statement_ComponentA[tComponent]["name"]
   put pVerbID into txAPI_Statement_ComponentA[tComponent]["id"]
   put pVerbDisplay into txAPI_Statement_ComponentA[tComponent]["display"]
   --put pVerbResultA into txAPI_Statement_ComponentA[tComponent]["result"]
   ## TODO  add the pVerbResultA to the verb
   ## the array for the result is constructed in the card VideoPlayer scripts
   # BUG  -- The Time value in the results array is not trucated at 3 decimal places
   if pVerbResultA is not empty then
      put pVerbResultA into txAPI_Statement_ComponentA[tComponent]["result"]
   end if
   set the xAPIVerbA of me to txAPI_Statement_ComponentA
end addxAPIVerb

function addxAPIResult pSuccess, pCompletion, pScore, pScaled, pDuration
   
   
end addxAPIResult


function convertToxAPITimeFormat pTime, pTimescale
   put round(pTime / pTimescale,3) into txAPITimeSeconds
   put trunc(pTime / pTimescale) into txAPITimeSecondswhole
   put (txAPITimeSeconds - txAPITimeSecondswhole) * 1000 into tSecondsThousands
   repeat until the number of characters of tSecondsThousands = 3
      put tSecondsThousands & "0" into tSecondsThousands
   end repeat
   return txAPITimeSecondswhole & "." & tSecondsThousands
end convertToxAPITimeFormat


# this is miscellaneous code that I used when creating the stack to automatically number cards
--on newcard
--   put the number of this card - 1 into field "Number" of this card
--end newcard



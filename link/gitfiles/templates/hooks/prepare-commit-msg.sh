#!/bin/bash

commitMsgFile=$1
commitMode=$2

BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`

if [ -z "$BRANCHES_TO_SKIP"  ]; then
  BRANCHES_TO_SKIP=(master develop test)
fi
BRANCH_EXCLUDED=$(printf "%s\n" "${BRANCHES_TO_SKIP[@]}" | grep -c "^$BRANCH_NAME$")
BRANCH_IN_COMMIT=$(grep -c "\[$BRANCH_NAME\]" $1)

# $2 is the commit mode
# if $2 == 'commit'  => user used `git commit`
# if $2 == 'message' => user used `git commit -m '...'`

existingMsg=`cat $commitMsgFile`
if [ "$commitMode" = "message" ]; then

   if [ -n "$BRANCH_NAME"  ] && ! [[ $BRANCH_EXCLUDED -eq 1  ]] && ! [[ $BRANCH_IN_COMMIT -ge 1  ]]; then 
      echo -n "[$BRANCH_NAME] " > $commitMsgFile
      echo $existingMsg >> $commitMsgFile
   fi

else   # "commit" 

    firstline=`head -n1 $commitMsgFile`

   # We check the fist line of the commit message file.
   # If it's an empty string then user didn't use `git commit --amend` so we can fill the commit msg file
   if [ -z "$firstline" ]; then
      echo "[$BRANCH_NAME] " > $commitMsgFile
   fi

fi


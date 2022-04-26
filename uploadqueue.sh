#!/bin/sh

# check for a list of generated wacz
if [ -f "queue-done.txt" ]
then 
  # work from a backup of the queue file, so we can update queue.txt on-the-fly
  cp queue-done.txt queue-uploadrun.txt
  COUNT=`grep -c '$' queue-uploadrun.txt`
  echo ┌
  echo │  found ${COUNT} entries to upload
else
  touch queue-done.txt
  echo ┌
  echo │  no queue-done file - exiting
  echo └
  exit 0
fi

# loop through each line of queue-done.txt
while read SITE; do
  # define the collection name based on the site - remove protocol and trailing slashes; change dots and slashes to dashes
  COLLECTION=`echo ${SITE} | sed -r 's/^(https?:)\/\///; s/\/+$//g; s/[./]/-/g'`

  echo │  collection\: ${COLLECTION}

  aws s3 cp crawls/collections/${COLLECTION}/${COLLECTION}.wacz s3://sucho-wacz-upload/
  EXITCODE=$?

  if [ $EXITCODE -eq 0 ]
  then
    echo ${SITE} >> queue-uploaded.txt
    echo │  uploaded with apparent success - moving to queue\-uploaded.txt
  else
    echo ${SITE} >> queue-uploaderrors.txt
    echo │  \[!\] upload resulted in errors - moving to queue\-uploaderrors.txt
  fi

  tail -n +2 queue-done.txt > queue-tmp.txt
  mv queue-tmp.txt queue-done.txt

  echo │  looking for next job...
  echo ├
done <queue-uploadrun.txt

echo │  finished upload queue :¬\)
echo └

exit 0

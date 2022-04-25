#!/bin/sh

if [ -f "queue.txt" ]
then
  # work from a backup of the queue file, so we can update queue.txt on-the-fly
  cp queue.txt queue-run.txt
else
  touch queue.txt
  echo ┌
  echo │  no queue file - exiting
  echo └
  exit 0
fi

echo ┌

# loop through each line of queue.txt
while read SITE; do
  # define the collection name based on the site - remove protocol and trailing slashes; change dots and slashes to dashes
  COLLECTION=`echo ${SITE} | sed -r 's/^(https?:)\/\///; s/\/+$//g; s/[./]/-/g'`
  URL="https://`echo ${SITE} | sed -r 's/^(https?:)\/\///'`"

  MAPS="-v $PWD/crawls:/crawls/"
  CMD="webrecorder/browsertrix-crawler crawl"
  ARGS="--collection \"${COLLECTION}\" --workers 8 --saveState \"always\" --scopeType \"host\" --seeds \"${URL}\" --timeout 300 --generateWACZ --exclude \"\[?&]share=|wp-login.php\""

  echo │  url\: ${URL}
  echo │  collection\: ${COLLECTION}

  echo docker run ${MAPS} ${CMD} ${ARGS} >> queue-commands.txt
  docker run ${MAPS} ${CMD} ${ARGS}

  EXITCODE=$?
  if [ $EXITCODE -eq 0 ]
  then
    echo ${SITE} >> queue-done.txt
    echo │  finished with apparent success - moving to queue\-done.txt
  else
  	echo ${SITE} >> queue-errors.txt
  	echo │  \[!\] finished with errors - moving to queue\-errors.txt

  fi

  tail -n +2 queue.txt > queue-tmp.txt
  mv queue-tmp.txt queue.txt

  echo │  looking for next job...
  echo ├
done <queue-run.txt

echo │  finished queue :¬\)
echo └

exit 0

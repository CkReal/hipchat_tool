#!/bin/sh
TOKEN={{CHANGE YOUR ADMIN APITOKEN}}

usage()
{
      echo "Usage: $(basename $0) [mail address]"
        exit 1
}

(test "$#" != "1") && usage

USER_EMAIL=$1

#
#HipChatからユーザと部屋の情報を取得
#
USER_LIST=`curl -s "https://api.hipchat.com/v1/users/list?format=json&auth_token=${TOKEN}"`
ROOM_LIST=`curl -s "https://api.hipchat.com/v1/rooms/list?format=json&auth_token=${TOKEN}"`

#
#取得したHipChatの情報と引数のメールアドレスを照会
#
USER_ID=`echo ${USER_LIST} | jq ".users[] | select(.email == \"${USER_EMAIL}\") | .user_id"`
USER_NAME=`echo ${USER_LIST} | jq ".users[] | select(.email == \"${USER_EMAIL}\") | .name"`

OWNER_ROOM=`echo ${ROOM_LIST} | jq ".rooms[] | select(.owner_user_id == ${USER_ID}) | .name"`

#
#引数のメールアドレスの所有部屋を表示
#
echo "${USER_NAME} ${USER_EMAIL} 所有部屋一覧"
echo "======================================="
echo "${OWNER_ROOM}"

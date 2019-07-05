#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export $(cat ${DIR}/variables.env | xargs)
source /usr/local/bin/tc_variables.sh

venvdir="${venvDirectory}/${DJANGO_APP_NAME}_venv"
source "${venvdir}/bin/activate"

pip install -r "${DIR}/requirements.txt"

_int() {
  kill -TERM "$child" 2>/dev/null
  exit 130
}

_term() {
  kill -TERM "$child" 2>/dev/null
  exit 0
}

trap _int SIGINT
trap _term SIGTERM

python "${DIR}/myapp/manage.py" makemigration
python "${DIR}/myapp/manage.py" migrate
python "${DIR}/myapp/manage.py" runserver 0.0.0.0:${WEBSERVER_PORT} &
python "${DIR}/asyncmsg/main.py"

child=$!
wait ${child}
exit $?
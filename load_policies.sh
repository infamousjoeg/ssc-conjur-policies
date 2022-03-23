#!/bin/bash

SESSION_TOKEN=""

main () {
  SESSION_TOKEN=$(authenticate)
  # Begin loading policies
  load_policy root root.yml
}

def authenticate () {
  curl -k -s --header "Accept-Encoding: base64" -X POST --data "$CONJUR_API_KEY" https://conjur.cybr.rocks/authn/cyberarkdemo/admin/authenticate
}

def load_policy () {
  curl -k -s --header "Authorization: Token token=\"$SESSION_TOKEN\"" -X POST -d "$(cat $2)" https://conjur.cybr.rocks/policies/cyberarkdemo/policy/"$1" > /dev/null
}

main "$@"

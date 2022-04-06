#!/bin/bash

export SESSION_TOKEN=""

main () {
  SESSION_TOKEN=$(authenticate host%2Fci%2Fjenkins%2Fconjur-policies)
  # Begin loading policies
  load_policy root root.yml
  load_policy root users.yml
  load_policy root groups.yml
  load_policy root grants/grants_users.yml
  load_policy ci ci/jenkins/jenkins.yml
  load_policy ci/jenkins ci/jenkins/conjur-policies.yml
  load_policy ci/jenkins ci/jenkins/cybr-cli.yml
  load_policy ci ci/github/github.yml
  load_policy cd cd/nexus/nexus.yml
  load_policy cd/nexus cd/nexus/cybr-cli.yml
  load_policy cd cd/ansible/ansible.yml
  load_policy cd/ansible cd/ansible/ops-team-1.yml
  load_policy root authn/authn-jwt-jenkins.yml
  load_policy root grants/grants_cd.yml
  load_policy root grants/grants_authn.yml
  load_policy root grants/grants_hosts.yml
}

authenticate () {
  curl -k -s --header "Accept-Encoding: base64" -X POST --data "$CONJUR_API_KEY" https://conjur.cybr.rocks/authn/cyberarkdemo/"$1"/authenticate
}

load_policy () {
  urlencoded_policy=$(echo -n "$1" | sed 's/\//\%2F/g')
  curl -k -s --header "Authorization: Token token=\"$SESSION_TOKEN\"" -X POST -d "$(cat "$2")" https://conjur.cybr.rocks/policies/cyberarkdemo/policy/"$urlencoded_policy"
}

main "$@"

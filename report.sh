#!/bin/bash

#/var/eyprepos
REPOBASEDIR="/home/jprats/git/docker-gitrepoinfo/tmp"

# TODO: analitzar tag

mkdir -p "${REPOBASEDIR}"

if [ -z "$1" ];
then
  echo "which repo what to analyze today?"
  exit 1
fi

function gitclone()
{
  REPO_URL=$1

  REPO_NAME=${REPO_URL##*/}
  REPO_NAME=${REPO_NAME%.*}

  cd ${REPOBASEDIR}

  if [ -d "${REPOBASEDIR}/${REPO_NAME}" ];
  then
    rm -fr "${REPOBASEDIR}/${REPO_NAME}"  > /dev/null 2>&1
  fi

  git clone ${REPO_URL} > /dev/null 2>&1
  cd ${REPO_NAME}
}

function is_puppet_module()
{
  IS_PUPPET_MODULE="false"

  if [ -f "${REPOBASEDIR}/${REPO_NAME}/metadata.json" ] && [ -d "${REPOBASEDIR}/${REPO_NAME}/manifests" ] && [ -f "${REPOBASEDIR}/${REPO_NAME}/manifests/init.pp" ];
  then
    IS_PUPPET_MODULE="true"
  fi
}

function has_changelog()
{
  CHANGELOG_FILES_COUNT=$(find "${REPOBASEDIR}/${REPO_NAME}" -type f -iname changelog.md | wc -l)

  if [ "${CHANGELOG_FILES_COUNT}" -eq 1 ];
  then
    HAS_CHANGELOG="true"
    CHANGELOG_FILE="\"$(find "${REPOBASEDIR}/${REPO_NAME}" -type f -iname changelog.md)\""
  else
    HAS_CHANGELOG="false"
    CHANGELOG_FILE="null"
  fi
}

function has_readme()
{
  README_FILES_COUNT=$(find "${REPOBASEDIR}/${REPO_NAME}" -type f -iname readme.md | wc -l)

  if [ "${README_FILES_COUNT}" -eq 1 ];
  then
    HAS_README="true"
    CHANGELOG_FILE="\"$(find "${REPOBASEDIR}/${REPO_NAME}" -type f -iname readme.md)\""
  else
    HAS_README="false"
    README_FILE="null"
  fi
}

gitclone "$1"
is_puppet_module
has_changelog
has_readme

echo -e "{"
echo -e "\t\"${REPO_NAME}\":"
echo -e "\t{"
echo -e "\t\t\"is_puppet_module\": ${IS_PUPPET_MODULE},"
echo -e "\t\t\"has_changelog\": ${HAS_CHANGELOG},"
echo -e "\t\t\"found_changelog\": ${CHANGELOG_FILE},"
echo -e "\t\t\"has_readem\": ${HAS_CHANGELOG},"
echo -e "\t\t\"found_readme\": ${CHANGELOG_FILE}"
echo -e "\t}"
echo -e "}"

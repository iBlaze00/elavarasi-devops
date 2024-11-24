#!/bin/bash

# Check if a branch name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <branch_name>"
  exit 1
fi

BRANCH_NAME=$1
MAIN_BRANCH="main"

echo "Switching to branch '$BRANCH_NAME'..."
git checkout $BRANCH_NAME
if [ $? -ne 0 ]; then
  echo "Error: Failed to switch to branch '$BRANCH_NAME'."
  exit 1
fi

echo "Pulling latest changes from remote for '$BRANCH_NAME'..."
git pull origin $BRANCH_NAME
if [ $? -ne 0 ]; then
  echo "Error: Failed to pull changes for branch '$BRANCH_NAME'."
  exit 1
fi

echo "Running tests..."
# Replace the below line with your test command
./run_tests.sh
if [ $? -ne 0 ]; then
  echo "Tests failed. Aborting merge."
  exit 1
fi

echo "Tests passed. Switching to '$MAIN_BRANCH'..."
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error: Failed to switch to main branch."
  exit 1
fi

echo "Pulling latest changes from remote for '$MAIN_BRANCH'..."
git pull origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error: Failed to pull changes for main branch."
  exit 1
fi

echo "Merging '$BRANCH_NAME' into '$MAIN_BRANCH'..."
git merge $BRANCH_NAME
if [ $? -ne 0 ]; then
  echo "Error: Merge conflict or other issue occurred."
  exit 1
fi

echo "Pushing merged changes to remote..."
git push origin $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Error: Failed to push changes to remote main branch."
  exit 1
fi

echo "Branch '$BRANCH_NAME' successfully merged into '$MAIN_BRANCH'!"

exit 0

#!/bin/bash

while getopts ':b:n:p:r:t:l:u:c' OPTION; do 

    case "$OPTION" in
        b) basebranch="$OPTARG" ;;
        n) newbranch="$OPTARG" ;;
        p) fromproject="$OPTARG" ;;
        r) fromrepo="$OPTARG" ;;
        t) toproject="$OPTARG" ;;
        l) torepo="$OPTARG" ;;
        u) pushtouserrepo="$OPTARG" ;;
        c) commitid="$OPTARG" ;;
        ?) echo "Error: Unknown option"
           usage
           exit 1
           ;;
    esac
done 

usage() {
    echo " Usage: <-bn> [-prus] "
    echo "-b: base branch from which intermediate branch needs to create"
    echo "-n: name of intermediate branch"
    echo "-p: name of project that needs to be cloned"
    echo "-r: name of repo to be cloned"
    echo "-t: name of project where new branch needs to push"
    echo "-l: name of repo where new branch needs to push"
    echo "-u: set to be true if new branch needs to be pushed to user remote repo"
    echo "-c: commit id in base branch from which code cut needs to be done"
}


createworkspace() {
    userid=$(whoami)
    rm -fr /var/tmp/$userid
    echo "creating local workspace in /var/tmp"
    cd /var/tmp ; mkdir $userid ; cd $userid 
    if [[ $? != 0 ]]; then
        echo "fail to create workspace"
        exit 1
    fi
}

addremoterepo() {
    pushtorepo=https://github.com/$toproject/$torepo.git 
    clonefromrepo=https://github.com/$fromproject/$fromrepo.git 
}

executegit() {
    git init
    echo "adding remote repo.."
    git remote add sourcerepo $clonefromrepo
    git remote add destinationrepo $pushtorepo
    git remote -v
    echo "fetching $basebranch"
    git fetch sourcerepo $basebranch --no-tags
    git checkout sourcerepo/$basebranch
    if [[ -z $commitid ]]; then
        git checkout -b $newbranch
    else
        git checkout -b $newbranch $commitid
    fi
    if [[ $? == 0 ]]; then
        git push destinationrepo --set-upstream $newbranch
        if [[ $? == 0 ]]; then
            echo "branch $newbranch is pushed successfully to $pushtorepo" 
        else 
            echo "Error: while pushing branch $newbranch to $pushtorepo"
        fi
    else
        echo "Error: not able to create $newbranch"
    fi
}

createworkspace
addremoterepo
executegit
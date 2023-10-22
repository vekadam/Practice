checkargument() {
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
pushtorepo=https://github.com/$toproject/$torepo.git 
clonefromrepo=https://github.com/$fromproject/$fromrepo.git 
echo $pushtorepo
}




checkargument

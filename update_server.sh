

find_and_download () {
    curl -s "$1" > ~/tmp.json
    cat ~/tmp.json | jq -r '.[] | select(.type=="file") | .download_url' | while read url; do
        echo "Downloading: $url"
        curl -L -o $2$(basename $url) $url
    done
    cat directory.json | jq -r '.[] | select(.type=="dir") | .url' | while read dir_url; do
        new_dir= basename $dir_url
        mkdir "$2$new_dir"
        find_and_download $dir_url "$2$new_dir"
    done
}


while getopts "mpco" opt; do
    case ${opt} in
        m)
            curl -s "https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/intalations/mods" > ~/tmp.json

            # Extract and download files
            cat ~/tmp.json | jq -r '.[] | select(.type=="file") | .download_url' | while read url; do
                echo "Downloading: $url"
                curl -L -o ~/server/mods/$(basename $url) $url
            done
            ;;
        p)
            curl -s "https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/plugins" > ~/tmp.json

            # Extract and download files
            cat ~/tmp.json | jq -r '.[] | select(.type=="file") | .download_url' | while read url; do
                echo "Downloading: $url"
                curl -L -o ~/server/plugins/$(basename $url) $url
            done
            ;;
        c)
            
            find_and_download https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/intalations/config ~/server/config/
            # Extract and download files

            ;;
        o)
            file=$OPTARG
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            usage
            ;;
    esac
done

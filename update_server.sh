
while getopts "mpo" opt; do
    case $opt in
        m)
            curl -s "https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/instalations/mods" > ~/tmp.json

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
        o)
            echo "Not implemented yet"
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

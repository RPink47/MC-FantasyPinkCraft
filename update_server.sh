
while getopts "mpco" opt; do

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
        c)
            curl -s "https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/instalations/config" > ~/tmp.json
            cat ~/tmp.json | jq -r '.[] | select(.type=="file") | .download_url' | while read url; do
                echo "Downloading: $url"
                curl -L -o ~/server/config/$(basename $url) $url
            done

            cat ~/tmp.json | jq -r '.[] | select(.type=="dir") | .url' | while read dir_url; do
                tmp= basename $dir_url
                name=${tmp%%\?*}
                curl -s "https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/instalations/config/$name" > ~/dir_tmp.json
                mkdir ~/server/config/$name
                cat ~/dir_tmp.json | jq -r '.[] | select(.type=="file") | .download_url' | while read url; do
                    curl -L -o ~server/config/$name/$(basename $url) $url
                done
                cat ~/dir_tmp.json | jq -r '.[] | select(.type=="dir") | .url' | while read sub_dir_url; do
                    sub_tmp= basename $sub_dir_url
                    sub_name=${sub_tmp%%\?*}
                    curl -s "https://api.github.com/repos/RPink47/MC-FantasyPinkCraft/contents/instalations/config/$sub_name" > ~/sub_dir_tmp.json
                    mkdir ~server/config/$name/$sub_name
                    cat ~/sub_dir_tmp.json | jq -r '.[] | select(.type=="file") | .download_url' | while read url; do
                        curl -L -o ~server/config/$name/$sub_name/$(basename $url) $url
                    done
                done
            done
            ;;
        o)
            echo 'Please use: curl -L -o ~/update_server.sh "https://raw.githubusercontent.com/RPink47/MC-FantasyPinkCraft/main/update_server.sh"'
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

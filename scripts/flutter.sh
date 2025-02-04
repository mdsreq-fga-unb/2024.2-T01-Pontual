#!/bin/bash
echo ""
if [[ $# == 0 ]]; then
    find ~/.pub-cache/hosted/pub.dev/http-1.3.0/lib/src -name "browser_client.dart" -type f -exec sed -i 's/bool withCredentials = false/bool withCredentials = true/g' {} \;
    echo "http package browser client patched!"
elif [[ $1 == "revert" ]]; then
    find ~/.pub-cache/hosted/pub.dev/http-1.3.0/lib/src -name "browser_client.dart" -type f -exec sed -i 's/bool withCredentials = true/bool withCredentials = false/g' {} \;
    echo "http package browser client patch reverted!"
else
    echo "use this patch without cmd line argument or with \"revert\""
    echo "e.g.: $ sh patch_local_cookie_cors_restriction.sh revert"
fi
echo ""
exit 0
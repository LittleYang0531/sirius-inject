# sirius-inject

## What I did?

- Inject network_security_config.xml into `com.kms.worlddaistar`
- Update package name to `com.kms.worlddaistar2`
- Enable debuggable

## How to use?

- Download all apks in [releases](https://github.com/LittleYang0531/sirius-inject/releases/latest)
- Install by command below:

```bash
adb install-multiple base_signed.apk config_signed.apk unity_signed.apk
```

## Anyproxy Script

If you are Mainland China users, you can use Anyproxy script below to connect to World Dai Star Server directly.

```javascript
// main.js
module.exports = {
        summary: "World Dai Star",
        *beforeSendRequest(requestDetail) {
        if (requestDetail.requestOptions.path.indexOf("wds-stellarium.com") != -1) {
                console.log("Hacked!");
                var url = requestDetail.protocol + ":" + requestDetail.requestOptions.path;
                if (url.indexOf("assets.wds") !== -1) url = "http://corsproxy.org/?" + encodeURIComponent(requestDetail.protocol + ":" + requestDetail.requestOptions.path);
                console.log(url);
                var x = new URL(url);
                var options = requestDetail.requestOptions;
                options.hostname = x.hostname;
                options.path = x.pathname + x.search;
                options.port = (x.protocol == "https:") ? 443 : 80;
                if (url.indexOf("assets.wds") !== -1) options.headers = {};
                var ret = {
                        url: url,
                        requestOptions: options,
                        protocol: x.protocol.substr(0, x.protocol.length - 1)
                }; console.log(ret);
                return ret;
        }
/*      if (requestDetail.requestOptions.hostname.indexOf("cdp.cloud.unity3d.com") != -1) {
                console.log("Hacked2");
                var url = "https://corsproxy.org/?" + encodeURIComponent(requestDetail.url);
                console.log(url);
                var x = new URL(url);
                var options = requestDetail.requestOptions;
                options.hostname = x.hostname;
                options.path = x.pathname + x.search;
                var ret = {
                        url: url,
                        requestOptions: options
                }; return ret;
        }*/
        },
        /**beforeDealHttpsRequest(requestDetail) {
                if (requestDetail.host.indexOf("unity3d.com") !== -1 || requestDetail.host.indexOf("wds-stellarium.com") !== -1) requestDetail.host = "corsproxy.org";
                console.log("Hacked");
                return true;
        }*/
}
```

and run Anyproxy by:

```bash
anyproxy --rule main.js -i --ignore-unauthorized-ssl
```
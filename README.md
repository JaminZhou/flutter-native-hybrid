# flutter-native-hybrid

## 如何使用release_ios.sh和release_release.sh

### iOS
执行`./release_ios.sh` 或 `sh release_ios.sh`

可选参数，缺省默认是`debug`:
* `debug`（不发布， 不改变版本号）
* `patch`（发布，且版本号加0.0.1）
* `minor`（发布，且版本号加0.1.0 最后一位重制0）
* `major`（发布，且版本号加1.0.0 最后两位重制0）
* `version` (发布，指定version)
podspec放在同一个仓库时，发布和不发布，处理是一样的


### Android
执行`./release_android.sh` 或 `sh release_android.sh`

参数需要一一对应，分别是`module` `version` `type`（临时这样处理，可以优化）
example: `./release_android.sh JZFlutter 0.0.1 snapshot`（需要装有maven）

module
* JZFlutter
* flutter_bridge
* flutter_boost
* xservice_kit

version
* 自定义即可

type
* snapshot（发布到libs-snapshots-local）
* release （发布到libs-releases-local）


## 提供的工具
如果你想试自己的.aar或者.zip ，可以使用这些工具

### maven私服
* https://artifactory.jaminzhou.com/artifactory/webapp/
* username: artifactory 
* password: artifactory

### pods.zip存储服务
* https://pods.jaminzhou.com/upload
* http method: PUT
* http body: from-data key: zip
* http response: application-json {url:xxxx}
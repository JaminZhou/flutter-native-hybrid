#!/usr/bin/env bash

MODULE_PATH=flutter/module
MODULE_NAME=JZFlutter

# $1 module
# $2 version
# $3 type (snapshot release)

module=$1
version=$2
type=$3

if [ "$module" == "" ]; then
	echo >&2 "No module set."
	exit 1
fi

if [ "$version" == "" ]; then
	echo >&2 "No version set."
	exit 1
fi

if [ "$type" == "" ]; then
	echo >&2 "No type set."
	exit 1
fi

CURRENT_PATH=$PWD
cd $MODULE_PATH

REPO_PATH=$CURRENT_PATH/repo/android

DgroupId="com.jaminzhou.app"
DartifactId=$module

suffix=""
if [ "$type" == "snapshot" ]; then
	suffix="-SNAPSHOT"
	Dversion="$version$suffix"
elif [ "$type" == "release" ]; then
	Dversion=$version
else
	echo >&2 "type is illegal. set snapshot release"
	exit 1
fi

# clear build
flutter clean
rm -rf $FLUTTER_ROOT/.pub-cache
rm -rf .android
rm -rf $REPO_PATH/.tmp*
flutter packages get

# flutter v1.5.4-hotfix.2 fix it do not need
# hook=$(<$REPO_PATH/android.hook)
# echo $hook >> .android/build.gradle

# https://github.com/flutter/flutter/issues/33909
# Issues when using macos 10.15  |  bad cput
flutter build apk --release
# flutter build apk --release --target-platform android-arm64

if [ "$module" == $MODULE_NAME ]; then
	aarfile=".android/Flutter/build/outputs/aar/flutter-release.aar"
else
	aarfile=$(grep -F "$module=" .flutter-plugins)
	aarfile=${aarfile#*=}/android/build/outputs/aar/$module-release.aar
fi

SETTING_FILE="settings.xml"
Dfile=".tmp.aar"
DpomFile=".tmp.pom"
Durl="https://artifactory.jaminzhou.com/artifactory/libs-$type-local"
DrepositoryId="$type"

cp "$aarfile" "$REPO_PATH/$Dfile"
cd $REPO_PATH

cp "$module.pom" "$REPO_PATH/$DpomFile"
sed -i "" -E "s/{suffix}/$suffix/g" $DpomFile
sed -i "" -E "s/{version}/$version/g" $DpomFile

# mvn -s settings.xml
mvn deploy:deploy-file -s=$SETTING_FILE -DgroupId=$DgroupId -DartifactId=$DartifactId -Dversion=$Dversion  -Dpackaging=aar -Dfile=$Dfile -DpomFile=$DpomFile -Durl=$Durl -DrepositoryId=$DrepositoryId

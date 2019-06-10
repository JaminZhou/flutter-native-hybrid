#!/usr/bin/env bash

MODULE_PATH=flutter/module
CURRENT_PATH=$PWD

POD_PATH="$CURRENT_PATH/repo/ios"
PODSPEC="JZFlutter.podspec"
PODSPEC_PATH="$CURRENT_PATH/$PODSPEC"

FRAMEWORK_PATH="$POD_PATH/Frameworks"
LIBRARY_PATH="$POD_PATH/Libraries"
HEADER_PATH="$POD_PATH/Headers"

debug=false
bump_type=$1
current_version=`cat $PODSPEC_PATH | grep "spec.version" | head -1 | cut -d \" -f2`
if [ "$1" == "major" ] || [ "$1" == "minor" ] || [ "$1" == "patch" ]; then
	IFS='.' read -a version_parts <<< "$current_version"

	major=${version_parts[0]}
	minor=${version_parts[1]}
	patch=${version_parts[2]}

	case "$1" in
		"major")
			major=$((major + 1))
			minor=0
			patch=0
			;;
		"minor")
			minor=$((minor + 1))
			patch=0
			;;
		"patch")
			patch=$((patch + 1))
			;;
	esac
	new_version="$major.$minor.$patch"
elif [ "$1" == "debug" ] || [ "$1" == "" ]; then
	debug=true
	new_version=$current_version
elif [ "$1" == "-version" ] && [ "$2" != "" ]; then
	new_version = "$2"
else
	echo >&2 "Illegal type, major minor patch debug or -version you can set."
	exit 1
fi

echo "Bumping $current_version to $new_version ($bump_type)"

cd $MODULE_PATH

rm -rf .ios
flutter clean
flutter packages get
# https://github.com/flutter/flutter/issues/33909
# Issues when using macos 10.15 & ios 13  |  bad cput
flutter build ios --release

# clear build
rm -rf $FRAMEWORK_PATH
rm -rf $LIBRARY_PATH
rm -rf $HEADER_PATH
mkdir $FRAMEWORK_PATH
mkdir $LIBRARY_PATH
mkdir $HEADER_PATH

echo "Copy frameworks..."
cp -r .ios/Flutter/App.framework $FRAMEWORK_PATH
cp -r .ios/Flutter/engine/Flutter.framework $FRAMEWORK_PATH

echo "Copy libraries..."
#plugins
cp build/ios/Release-iphoneos/*/*.a $LIBRARY_PATH

echo "Copy headers..."
find -L .ios/Flutter/.symlinks/*/ios/Classes -name \*.h -exec cp {} $HEADER_PATH \;

if [ "$debug" == "true" ]; then
	echo "Build x86_64"
	xcrun xcodebuild clean
	xcrun xcodebuild build -configuration Debug ARCHS='x86_64' -workspace .ios/Runner.xcworkspace -scheme Runner -sdk iphonesimulator -quiet
	APP_PATCH="$FRAMEWORK_PATH/App.framework/App"

	echo "lipo frameworks"
	lipo -create "$APP_PATCH" ".ios/Flutter/App.framework/App" -o "$APP_PATCH"
	cp -r ".ios/Flutter/App.framework/flutter_assets/" "$FRAMEWORK_PATH/App.framework/flutter_assets/"

	libraries=$(ls $LIBRARY_PATH)
	build_dir="../../build/ios"
	cd .ios/Pods
	for library in $libraries; do
		library=${library#*lib}
		library=${library%.a*}
		echo "Build library $library"
		xcrun xcodebuild build -configuration Debug ARCHS='x86_64' -target ${library} BUILD_DIR=$build_dir -sdk iphonesimulator -quiet

		echo "lipo library $library"
		lipo -create "$build_dir/Debug-iphonesimulator/$library/lib$library.a" "$LIBRARY_PATH/lib$library.a" -o "$LIBRARY_PATH/lib$library.a"
	done
else
	FLUTTER_PATCH="$FRAMEWORK_PATH/Flutter.framework/Flutter"
	lipo -remove x86_64 "$FLUTTER_PATCH" -o "$FLUTTER_PATCH"
fi

echo "Updating $PODSPEC"
podspec_sed_regex="s/$current_version/$new_version/g"
sed -i "" -E "$podspec_sed_regex" $PODSPEC_PATH

ZIP_NAME="JZFlutter-$new_version.zip"
UPLOAD_URL="https://pods.jaminzhou.com/upload"

cd $CURRENT_PATH
rm -rf $ZIP_NAME
zip -r "$CURRENT_PATH/$ZIP_NAME" repo/ios

cd $CURRENT_PATH
response=$(curl -X PUT -F "zip=@$ZIP_NAME" $UPLOAD_URL)

new_podsepc_source=$(awk 'BEGIN{FS="\""}{print $4}' <<< "${response}")
if [[ $new_podsepc_source == *".zip" ]]; then
	echo "Upload zip successfull: $new_podsepc_source"
	current_podsepc_source=`cat $PODSPEC_PATH | grep "spec.source" | head -1 | cut -d \" -f2`
	sed -i "" -E "s,$current_podsepc_source,$new_podsepc_source,g" $PODSPEC_PATH
else
	echo "Upload zip failure"
	exit 1
fi

echo "Successfull!"

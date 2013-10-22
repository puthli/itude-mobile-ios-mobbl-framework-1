default:
	xcodebuild -target "itude-mobile-ios-mobbl" -configuration Release
	xcodebuild -target "itude-mobile-ios-mobbl-i386" -configuration Release
	BUILD_DIR="build" BUILD_STYLE="Release" sh ../Scripts/CombineLibs.sh
	sh ../Scripts/iPhoneFramework.sh

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 xcodebuild -target itude-mobile-ios-mobbl-i386 -configuration Debug -sdk iphonesimulator4.3 build

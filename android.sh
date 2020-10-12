echo "Bootstrapping ..."
make clean
rm -f config.status
rm -f config.sub
./bootstrap
echo "Setting vars ..."
export NDK=~/Android/Sdk/ndk-bundle
#export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
# Only choose one of these, depending on your device...
export TARGET=aarch64-linux-android
#export TARGET=armv7a-linux-androideabi
#export TARGET=i686-linux-android
#export TARGET=x86_64-linux-android
# Set this to your minSdkVersion.
export API=24
# Configure and build.
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
echo "Configuring ..."
cp $HOME/projects/openssl/libcrypto.so ./libcrypto.so
# Android Gradle does not supported versioned soname
patchelf --set-soname libcrypto.so libcrypto.so
./configure --with-pcsc-provider=libPCSCAndroid.so PCSC_CFLAGS="-I$HOME/projects/PCSCAndroid/lib/src/main/cpp/include" PCSC_LIBS="-L$HOME/projects/PCSCAndroid/lib/build/intermediates/library_and_local_jars_jni/debug/jni/arm64-v8a -lPCSCAndroid" OPENSSL_LIBS="-L$PWD -lcrypto" OPENSSL_CFLAGS="-I$HOME/projects/openssl/include" LDFLAGS="-llog" CPPFLAGS="-I$NDK -Wno-deprecated-declarations" --host $TARGET --prefix=/usr --sysconfdir=/etc/opensc
make

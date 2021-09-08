export ANDROID_SDK_ROOT=~/Android/Sdk
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools/bin"

# Use bundled version of Java since Android development only supports Java 8
export JAVA_HOME="/opt/android-studio/jre"
export PATH="$PATH:$JAVA_HOME/bin"

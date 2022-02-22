FIREBASE_DIR="$PWD"

function updateAndroid() {
    cd ../android
    sed -i -e 's|#GDEFirebase|include(../GDEFirebase/CMakeLists.txt)|g' CMakeLists.txt
    sed -i -e 's|compileSdkVersion: [0-9][0-9],|compileSdkVersion: 32,|g' build.gradle
    sed -i -e "s|// *GOOGLE_SERVICES|\t\tclasspath 'com.google.gms:google-services:4.3.10'|g" build.gradle
    sed -i -e "s|// *FIREBASE|def firebase_cpp_sdk_dir = System.getProperty('firebase_cpp_sdk.dir')\ngradle.ext.firebase_cpp_sdk_dir = \"\$firebase_cpp_sdk_dir\"\nincludeBuild \"\$firebase_cpp_sdk_dir\"|g" settings.gradle
    ln -s ../GDEFirebase/firebase_cpp_sdk .

    if ! grep -q "systemProp.firebase_cpp_sdk.dir=$FIREBASE_DIR/firebase_cpp_sdk" "gradle.properties"; then
        printf "\n" >> gradle.properties
        echo "systemProp.firebase_cpp_sdk.dir=$FIREBASE_DIR/firebase_cpp_sdk" >> gradle.properties
    fi

    cd app
    sed -i -e "s|// *FIREBASE_APPLY_GOOGLE_SERVICES|apply plugin: 'com.google.gms.google-services'|g" build.gradle
    sed -i -e "s|// *FIREBASE_DEPENDENCIES|\timplementation platform('com.google.firebase:firebase-bom:29.1.0')\n\timplementation 'com.google.firebase:firebase-analytics'\n\timplementation 'com.google.firebase:firebase-auth:21.0.1'\n\timplementation 'com.google.android.gms:play-services-ads:19.0.0'|g" build.gradle
    sed -i -e "s|arguments \"-DANDROID_STL=c++_shared\", \"-DAPP_PLATFORM=android-21\"|arguments \"-DANDROID_STL=c++_shared\", \"-DAPP_PLATFORM=android-21 -DFIREBASE_CPP_SDK_DIR=\$gradle.firebase_cpp_sdk_dir\"|g" build.gradle
    sed -i -e "s|// *FIREBASE_APPLY_AND_DEPENDENCIES|apply from: \"\$gradle.firebase_cpp_sdk_dir/Android/firebase_dependencies.gradle\"\nfirebaseCpp.dependencies { \n\tanalytics\n\tauth\n\tdatabase\n\tadmob\n}|g" build.gradle
    cd ..

    cd app/src/main/java/com/example/android
    sed -i -e "s|// *FIREBASE_INIT|\t\tinitFireBaseAdds();|g" MainActivity.java
    sed -i -e "s|// *FIREBASE_DEFINE|\t@Override\n\tprotected void finalize() throws Throwable {\n\t\tsuper.finalize();\n\t\tdestroy();\n\t}\n\n\tpublic native void initFireBaseAdds();\n\tpublic native void destroy();\n|g" MainActivity.java
    cd ../../../../../../..
}

function chooseModuleToInstall() {
    read -r MODULE
    if [ "$MODULE" == 0 ]
    then
        cd ../..
        echo "Configuring Android..."
        ./addModule.sh ANDROID
        cd "$FIREBASE_DIR"
        updateAndroid
        return 0
    elif [  "$MODULE" == 3 ]
    then
        exit 0
    fi
    echo "Currently only ANDROID is supported, so choose 0"
    return 1
}

if ! [ -d firebase_cpp_sdk ]
then
    sudo apt install wget
    wget https://firebase.google.com/download/cpp && unzip cpp && rm cpp
fi

if [ -d ../android ]
then
    echo "Android module is already installed, so configuring it..."
    updateAndroid
else
    echo "To use the firebase module you need to have installed ANDROID, IOS or bot modules, choose [(0) ANDROID, (1) IOS, (2) BOTH, (3) exit] to continue:"
    chooseModuleToInstall
    SELECTED_MODULE=$?
    while [ SELECTED_MODULE == 1 ]; do
        echo "To use the firebase module you need to have installed ANDROID, IOS or bot modules, choose [(0) ANDROID, (1) IOS, (2) BOTH, (3) exit] to continue:"
        chooseModuleToInstall
        SELECTED_MODULE=$?
    done
fi

cd ../..
sed -i -e 's|#GDEFirebase|include(targets/GDEFirebase/CMakeLists.txt)|g' CMakeLists.txt

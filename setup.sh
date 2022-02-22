#sudo apt install wget
#
#if ! [ -d firebase_cpp_sdk ]
#then
#    wget https://firebase.google.com/download/cpp && unzip cpp && rm cpp
#fi

FIREBASE_DIR="$PWD"

if [ -d ../android ]
then
    cd ../android
    sed -i -e 's|#GDEFirebase|include(../GDEFirebase/CMakeLists.txt)|g' CMakeLists.txt
    sed -i -e 's|compileSdkVersion: [0-9][0-9],|compileSdkVersion: 32,|g' build.gradle
    sed -i -e "s|// *GOOGLE_SERVICES|\t\tclasspath 'com.google.gms:google-services:4.3.10'|g" build.gradle
#    ln -s ../GDEFirebase/firebase_cpp_sdk .
#    printf "\n" >> gradle.properties
#    echo "systemProp.firebase_cpp_sdk.dir=$FIREBASE_DIR/firebase_cpp_sdk" >> gradle.properties

    cd app
    sed -i -e "s|// *FIREBASE_APPLY_GOOGLE_SERVICES|apply plugin: 'com.google.gms.google-services'|g" build.gradle
    sed -i -e "s|// *FIREBASE_DEPENDENCIES|\timplementation platform('com.google.firebase:firebase-bom:29.1.0')\n\timplementation 'com.google.firebase:firebase-analytics'\n\timplementation 'com.google.firebase:firebase-auth:21.0.1'\n\timplementation 'com.google.android.gms:play-services-ads:19.0.0'|g" build.gradle
    sed -i -e "s|arguments \"-DANDROID_STL=c++_shared\", \"-DAPP_PLATFORM=android-21\"|arguments \"-DANDROID_STL=c++_shared\", \"-DAPP_PLATFORM=android-21 -DFIREBASE_CPP_SDK_DIR=\$gradle.firebase_cpp_sdk_dir\""
    sed -i -e "s|// *FIREBASE_APPLY_AND_DEPENDENCIES|apply from: \"\$gradle.firebase_cpp_sdk_dir/Android/firebase_dependencies.gradle\"\nfirebaseCpp.dependencies { \n\tanalytics\n\tauth\n\tdatabase\n\tadmob\n}|g" build.gradle
    cd ..
fi

cd ../..
sed -i -e 's|#GDEFirebase|include(targets/GDEFirebase/CMakeLists.txt)|g' CMakeLists.txt

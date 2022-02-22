sudo apt install wget

if ! [ -d firebase_cpp_sdk ]
then
    wget https://firebase.google.com/download/cpp && unzip cpp && rm cpp
fi

if [ -d ../android ]
then
    cd ../android
    set -i -e "s/#GDEFirebase/include(../GDEFirebase/CMakeLists.txt)/g"
    ln -s ../GDEFirebase/firebase_cpp_sdk .
    echo "systemProp.firebase_cpp_sdk.dir=$PWD/firebase_cpp_sdk" >> gradle.properties
fi

cd ../..
set -i -e "s/#GDEFirebase/include(targets/GDEFirebase/CMakeLists.txt)"

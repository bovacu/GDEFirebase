if ! [ -d firebase_cpp_sdk ]
then
    wget https://firebase.google.com/download/cpp?hl=es && unzip cpp?hl=es && rm cpp?hl=es
fi

if [ -d ../android ]
then
    cd ../android
    set -i -e "s/#GDEFirebase/include(../GDEFirebase/CMakeLists.txt)/g"
    ln -s ../GDEFirebase/firebase_cpp_sdk .
fi

cd ../..
set -i -e "s/#GDEFirebase/include(targets/GDEFirebase/CMakeLists.txt)"

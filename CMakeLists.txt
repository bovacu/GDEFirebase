include_directories(${CMAKE_CURRENT_LIST_DIR})

if(ANDROID)
    add_subdirectory(firebase_cpp_sdk)
    set(firebase_libs
            firebase_analytics
            firebase_auth
            firebase_database
            firebase_app
            firebase_admob
            )
    list(APPEND TARGET_LIBRARIES ${firebase_libs})
endif()

list(APPEND CPP_HEADERS ${CMAKE_CURRENT_LIST_DIR}/nativeCode/include/NativeAds.h)
list(APPEND CPP_SOURCES ${CMAKE_CURRENT_LIST_DIR}/nativeCode/src/NativeAds.cpp)
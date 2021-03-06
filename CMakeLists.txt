project(visualization.shadertoy)

cmake_minimum_required(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})

find_package(kodi REQUIRED)
find_package(p8-platform REQUIRED)

find_package(OpenGL)
if(OPENGL_FOUND)
  find_package(GLEW REQUIRED)
  set(INCLUDES ${OpenGL_INCLUDE_DIR}
               ${GLEW_INCLUDE_DIR})
  add_definitions(-DHAS_OPENGL)
  set(DEPLIBS ${OPENGL_LIBRARIES} ${GLEW_LIBRARIES})
else()
  find_package(OpenGLES2)
  if(OPENGLES2_FOUND)
    set(INCLUDES ${OPENGLES2_INCLUDE_DIR})
    add_definitions(-DHAS_GLES2 -DHAS_GLES)
    set(DEPLIBS ${OPENGLES2_LIBRARIES})
  else()
    message(FATAL_ERROR "No rendering API found. Bailing")
  endif()
endif()

include_directories(${INCLUDES}
                    ${KODI_INCLUDE_DIR}
                    ${p8-platform_INCLUDE_DIRS}
                    ${PROJECT_SOURCE_DIR}/lib/kissfft
                    ${CMAKE_INCLUDE_PATH})

add_subdirectory(lib/kissfft)

set(SHADERTOY_SOURCES src/lodepng.cpp
                      src/main.cpp)

set(DEPLIBS ${DEPLIBS} kissfft)

if(APPLE)
  set(DEPLIBS ${DEPLIBS} "-framework CoreVideo")
endif()

add_options(CXX ALL_BUILDS -std=c++11)

build_addon(visualization.shadertoy SHADERTOY DEPLIBS)

include(CPack)

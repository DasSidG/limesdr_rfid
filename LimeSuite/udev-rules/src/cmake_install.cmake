# Install script for directory: /home/sg723/LimeSuite/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/lime" TYPE FILE FILES
    "/home/sg723/LimeSuite/src/lime/LimeSuite.h"
    "/home/sg723/LimeSuite/src/VersionInfo.h"
    "/home/sg723/LimeSuite/src/Logger.h"
    "/home/sg723/LimeSuite/src/ErrorReporting.h"
    "/home/sg723/LimeSuite/src/SystemResources.h"
    "/home/sg723/LimeSuite/src/LimeSuiteConfig.h"
    "/home/sg723/LimeSuite/src/ADF4002/ADF4002.h"
    "/home/sg723/LimeSuite/src/lms7002m_mcu/MCU_BD.h"
    "/home/sg723/LimeSuite/src/lms7002m_mcu/MCU_File.h"
    "/home/sg723/LimeSuite/src/ConnectionRegistry/IConnection.h"
    "/home/sg723/LimeSuite/src/ConnectionRegistry/ConnectionHandle.h"
    "/home/sg723/LimeSuite/src/ConnectionRegistry/ConnectionRegistry.h"
    "/home/sg723/LimeSuite/src/lms7002m/LMS7002M.h"
    "/home/sg723/LimeSuite/src/lms7002m/LMS7002M_RegistersMap.h"
    "/home/sg723/LimeSuite/src/lms7002m/LMS7002M_parameters.h"
    "/home/sg723/LimeSuite/src/protocols/ADCUnits.h"
    "/home/sg723/LimeSuite/src/protocols/LMS64CCommands.h"
    "/home/sg723/LimeSuite/src/protocols/LMS64CProtocol.h"
    "/home/sg723/LimeSuite/src/protocols/LMSBoards.h"
    "/home/sg723/LimeSuite/src/protocols/dataTypes.h"
    "/home/sg723/LimeSuite/src/protocols/fifo.h"
    "/home/sg723/LimeSuite/src/Si5351C/Si5351C.h"
    "/home/sg723/LimeSuite/src/FPGA_common/FPGA_common.h"
    "/home/sg723/LimeSuite/src/API/lms7_device.h"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLimeSuite.so.17.12.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLimeSuite.so.17.12-1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLimeSuite.so"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/sg723/LimeSuite/udev-rules/src/libLimeSuite.so.17.12.0"
    "/home/sg723/LimeSuite/udev-rules/src/libLimeSuite.so.17.12-1"
    "/home/sg723/LimeSuite/udev-rules/src/libLimeSuite.so"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLimeSuite.so.17.12.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLimeSuite.so.17.12-1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libLimeSuite.so"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/home/sg723/LimeSuite/udev-rules/bin/LimeSuiteGUI")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI"
         OLD_RPATH "/home/sg723/LimeSuite/udev-rules/src:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/LimeSuiteGUI")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/sg723/LimeSuite/udev-rules/src/GFIR/cmake_install.cmake")
  include("/home/sg723/LimeSuite/udev-rules/src/oglGraph/cmake_install.cmake")
  include("/home/sg723/LimeSuite/udev-rules/src/tests/cmake_install.cmake")
  include("/home/sg723/LimeSuite/udev-rules/src/examples/cmake_install.cmake")

endif()


# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/sg723/LimeSuite

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/sg723/LimeSuite/udev-rules

# Include any dependencies generated for this target.
include src/CMakeFiles/boardEmulator.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/boardEmulator.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/boardEmulator.dir/flags.make

src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o: src/CMakeFiles/boardEmulator.dir/flags.make
src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o: ../src/boardEmulator.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/sg723/LimeSuite/udev-rules/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o"
	cd /home/sg723/LimeSuite/udev-rules/src && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o -c /home/sg723/LimeSuite/src/boardEmulator.cpp

src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/boardEmulator.dir/boardEmulator.cpp.i"
	cd /home/sg723/LimeSuite/udev-rules/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/sg723/LimeSuite/src/boardEmulator.cpp > CMakeFiles/boardEmulator.dir/boardEmulator.cpp.i

src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/boardEmulator.dir/boardEmulator.cpp.s"
	cd /home/sg723/LimeSuite/udev-rules/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/sg723/LimeSuite/src/boardEmulator.cpp -o CMakeFiles/boardEmulator.dir/boardEmulator.cpp.s

src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.requires:

.PHONY : src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.requires

src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.provides: src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.requires
	$(MAKE) -f src/CMakeFiles/boardEmulator.dir/build.make src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.provides.build
.PHONY : src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.provides

src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.provides.build: src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o


# Object files for target boardEmulator
boardEmulator_OBJECTS = \
"CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o"

# External object files for target boardEmulator
boardEmulator_EXTERNAL_OBJECTS =

src/boardEmulator: src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o
src/boardEmulator: src/CMakeFiles/boardEmulator.dir/build.make
src/boardEmulator: src/libLimeSuite.so.17.12.0
src/boardEmulator: /usr/lib/x86_64-linux-gnu/libsqlite3.so
src/boardEmulator: /usr/lib/x86_64-linux-gnu/libusb-1.0.so
src/boardEmulator: src/CMakeFiles/boardEmulator.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/sg723/LimeSuite/udev-rules/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable boardEmulator"
	cd /home/sg723/LimeSuite/udev-rules/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/boardEmulator.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/boardEmulator.dir/build: src/boardEmulator

.PHONY : src/CMakeFiles/boardEmulator.dir/build

src/CMakeFiles/boardEmulator.dir/requires: src/CMakeFiles/boardEmulator.dir/boardEmulator.cpp.o.requires

.PHONY : src/CMakeFiles/boardEmulator.dir/requires

src/CMakeFiles/boardEmulator.dir/clean:
	cd /home/sg723/LimeSuite/udev-rules/src && $(CMAKE_COMMAND) -P CMakeFiles/boardEmulator.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/boardEmulator.dir/clean

src/CMakeFiles/boardEmulator.dir/depend:
	cd /home/sg723/LimeSuite/udev-rules && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/sg723/LimeSuite /home/sg723/LimeSuite/src /home/sg723/LimeSuite/udev-rules /home/sg723/LimeSuite/udev-rules/src /home/sg723/LimeSuite/udev-rules/src/CMakeFiles/boardEmulator.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/boardEmulator.dir/depend


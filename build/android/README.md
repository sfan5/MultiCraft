MultiCraft: Android version
===========================

Controls
--------
The Android port doesn't support everything you can do on PC due to the
limited capabilities of common devices. What can be done is described
below:

While you're playing the game normally (that is, no menu or inventory is
shown), the following controls are available:
* Look around: touch screen and slide finger
* double tap: place a node or use selected item
* long tap: dig node
* touch shown buttons: press button
* Buttons:
** left upper corner: chat
** right lower corner: jump
** right lower corner: crouch
** left lower corner: walk/step...
   left up right
       down
** left lower corner: display inventory

When a menu or inventory is displayed:
* double tap outside menu area: close menu
* tap on an item stack: select that stack
* tap on an empty slot: if you selected a stack already, that stack is placed here
* drag and drop: touch stack and hold finger down, move the stack to another
  slot, tap another finger while keeping first finger on screen
  --> places a single item from dragged stack into current (first touched) slot

Special settings
----------------
There are some settings especially useful for Android users. MultiCraft's config
file can usually be found at /sdcard/Android/data/mobi.MultiCraft/files.

* gui_scaling: this is a user-specified scaling factor for the GUI- In case
               main menu is too big or small on your device, try changing this
               value.

Requirements
------------

In order to build, your PC has to be set up to build MultiCraft in the usual
manner (see the regular MultiCraft documentation for how to get this done).
In addition to what is required for MultiCraft in general, you will need the
following software packages. The version number in parenthesis denotes the
version that was tested at the time this README was drafted; newer/older
versions may or may not work.

* android SDK (28+)
* android NDK (r17c)
* wget
* g++-multilib
* m4
* gettext

Additionally, you'll need to have an Internet connection available on the
build system, as the Android build will download some source packages.

Build
-----

Debug build:
* Enter "build/android" subdirectory
* Execute "make"
* Answer the questions about where SDK and NDK are located on your filesystem
* Wait for build to finish

After the build is finished, the resulting apk can be fond in
build/android/bin/. It will be called MultiCraft-debug.apk

Release build:

* In order to make a release build you'll have to have a keystore setup to sign
  the resulting apk package. How this is done is not part of this README. There
  are different tutorials on the web explaining how to do it
  - choose one yourself.

* Once your keystore is setup, enter build/android subdirectory and create a new
  file "ant.properties" there. Add following lines to that file:

  > key.store=<path to your keystore>
  > key.alias=MultiCraft

* Execute "make release"
* Enter your keystore as well as your Mintest key password once asked. Be
  careful it's shown on console in clear text!
* The result can be found at "bin/MultiCraft-release.apk"

Other things that may be nice to know
------------
* The environment for Android development tools is saved within Android build
  build folder. If you want direct access to it do:

  > make envpaths
  > . and_env

  After you've done this you'll have your path and path variables set correct
  to use adb and all other Android development tools

* You can build a single dependency by calling make and the dependency's name,
  e.g.:

  > make irrlicht

* You can completely cleanup a dependency by calling make and the "clean" target,
  e.g.:

  > make clean_irrlicht


  The new build system MultiCraft Android is still WIP, but it is fully functional and is designed to speed up and simplify the work, as well as adding the possibility of cross-platform build.
  The Makefile is no longer used and will be removed in future releases. Use the "Start" script, which will automatically load pre-assembled dependencies, prepare localization files and archive all necessary files.
  Then you can use "./gradlew assemblerelease" or "./graldew assembledebug" from the command line or use Android Studio and click the build button.

  When using gradlew, the newest NDK will be downloaded and installed automatically. Or you can create a local.properties file and specify sdk.dir and ndk.dir yourself.
  The script will automatically create an APK for all the architectures specified in build.gradle.

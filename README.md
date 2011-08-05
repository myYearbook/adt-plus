Usage
-----

To install to all devices in 'device' state, attach the -a flag (no value)
   `adb -a install my.apk`

To install an APK from a URL (requires curl), simply use a URL in place of the
APK file path. The script will prompt you for a username and password
if the server initially comes back with a 401 or 403 error code.
   `adb install http://my.internal.jenkins.server/view/My%20Project/job/my-job/lastSuccessfulBuild/artifact/bin/my-debug_2011-04-01_18-45-14.apk`

To restrict logcat output to a given package name:

    package_log <package name> [-d | -e | -s <serial>]

Contributors
------------

* Dallas Gutauckis <dallas@myyearbook.com>
* Joe Hansche <jhansche@myyearbook.com>

# The code will search for the upstream drake-config.cmake file
# installed under the root of the ROS installation + /opt/drake
# (i.e /opt/ros/rolling/opt/drake ).

# drake_DIR will return the absolute path to the ROS package
# of drake (share/drake/cmake under the ROS root installation)
# The relative path should drive us to the root of the drake
# upstream installation done under ROS.
set(drake_path "${drake_DIR}/../../../opt/drake")

# Since the upstream installation has the same CMake module name
# than the ROS package we need to unset the cache variable
# that points to the ROS package to be sure to force the
# find_package to find the drake config module under the
# paths
unset(drake_DIR CACHE)

find_package(drake PATHS ${drake_path} NO_DEFAULT_PATH)

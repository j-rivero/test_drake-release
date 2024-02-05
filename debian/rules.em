#!/usr/bin/make -f
# -*- makefile -*-
# Sample debian/rules that uses debhelper.
# This file was originally written by Joey Hess and Craig Small.
# As a special exception, when this file is copied by dh-make into a
# dh-make output file, you may use that output file without restriction.
# This special exception was added by Craig Small in version 0.37 of dh-make.

# Uncomment this to turn on verbose mode.
export DH_VERBOSE=1
# TODO: remove the LDFLAGS override.  It's here to avoid esoteric problems
# of this sort:
#  https://code.ros.org/trac/ros/ticket/2977
#  https://code.ros.org/trac/ros/ticket/3842
export LDFLAGS=
export PKG_CONFIG_PATH=@(InstallationPrefix)/lib/pkgconfig
# Explicitly enable -DNDEBUG, see:
# 	https://github.com/ros-infrastructure/bloom/issues/327
export DEB_CXXFLAGS_MAINT_APPEND=-DNDEBUG
ifneq ($(filter nocheck,$(DEB_BUILD_OPTIONS)),)
	BUILD_TESTING_ARG=-DBUILD_TESTING=OFF -DCATKIN_ENABLE_TESTING=OFF
endif

DEB_HOST_GNU_TYPE ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)

%:
	dh $@@ -v --buildsystem=cmake --builddirectory=.obj-$(DEB_HOST_GNU_TYPE)

override_dh_auto_configure:
	# In case we're installing to a non-standard location, look for a setup.sh
	# in the install tree that was dropped by catkin, and source it.  It will
	# set things like CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
	if [ -f "@(InstallationPrefix)/setup.sh" ]; then . "@(InstallationPrefix)/setup.sh"; fi && \
	dh_auto_configure -- \
		-DCATKIN_BUILD_BINARY_PACKAGE="1" \
		-DCMAKE_INSTALL_PREFIX="@(InstallationPrefix)" \
		-DCMAKE_PREFIX_PATH="@(InstallationPrefix)" \
		$(BUILD_TESTING_ARG)

override_dh_auto_build:
	# In case we're installing to a non-standard location, look for a setup.sh
	# in the install tree that was dropped by catkin, and source it.  It will
	# set things like CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
	#
	# j-rivero: inject DESTDIR since the bazel Cmake wrapper in Drake will run
	# the install target when executing make. That target will install
	# Drake generated code in this step. Injecting DESTDIR since the Drake
	# CMake wrapper is sensible to transform it into an installation prefix.
	export DESTDIR=$(CURDIR)/debian/@(Package)/
	if [ -f "@(InstallationPrefix)/setup.sh" ]; then . "@(InstallationPrefix)/setup.sh"; fi && \
	DESTDIR=$(CURDIR)/debian/@(Package)/ dh_auto_build

override_dh_auto_test:
	# In case we're installing to a non-standard location, look for a setup.sh
	# in the install tree that was dropped by catkin, and source it.  It will
	# set things like CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
	echo -- Running tests. Even if one of them fails the build is not canceled.
	if [ -f "@(InstallationPrefix)/setup.sh" ]; then . "@(InstallationPrefix)/setup.sh"; fi && \
	dh_auto_test || true

override_dh_shlibdeps:
	# In case we're installing to a non-standard location, look for a setup.sh
	# in the install tree that was dropped by catkin, and source it.  It will
	# set things like CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
	if [ -f "@(InstallationPrefix)/setup.sh" ]; then . "@(InstallationPrefix)/setup.sh"; fi && \
	dh_shlibdeps -l$(CURDIR)/debian/@(Package)/@(InstallationPrefix)/lib/

override_dh_auto_install:
	# In case we're installing to a non-standard location, look for a setup.sh
	# in the install tree that was dropped by catkin, and source it.  It will
	# set things like CMAKE_PREFIX_PATH, PKG_CONFIG_PATH, and PYTHONPATH.
	if [ -f "@(InstallationPrefix)/setup.sh" ]; then . "@(InstallationPrefix)/setup.sh"; fi && \
	echo "Find build files:" && \
	ls -R DESTDIR=$(CURDIR)/debian/@(Package)/ && \
	echo "Run auto_build again:" && \
	DESTDIR=$(CURDIR)/debian/@(Package)/ dh_auto_build && \
	dh_auto_install && \
	echo "Post install files:" && \
	ls -R DESTDIR=$(CURDIR)/debian/@(Package)/

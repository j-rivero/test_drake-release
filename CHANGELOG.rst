^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package drake_vendor
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1.25.5 (2024-02-03)
-------------------
* Add workaround to get lsb-release into the system
  Remove previous patch
* Contributors: Jose Luis Rivero

1.25.4 (2024-02-02)
-------------------
* Be explicit about patches
* Add testing in github-actions
* Contributors: Jose Luis Rivero

1.25.3 (2024-02-02)
-------------------
* Rework patches
* Contributors: Jose Luis Rivero

1.25.2 (2024-02-02)
-------------------
* Use patch to skip lsb_release. Testing proposes.
* Contributors: Jose Luis Rivero

1.25.1 (2024-02-01)
-------------------
* Rename the project to drake_vendor
  Name change is waiting to resolve `#7 <https://github.com/j-rivero/ros-drake-vendor/issues/7>`_ but this name change was
  required in order to make the examples to work when using the
  drake-extras.cmake.

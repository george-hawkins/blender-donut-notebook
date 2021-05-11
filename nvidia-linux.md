Nvidia on Linux
===============

This page covers issues I experienced with using the Nvidia driver on Linux. It covers installing the latest version, the discrepancy between driver and tool versions and resolving the issue with CUDA becoming unavailable after wake from suspend.

Installing the latest driver
----------------------------

You need to use the proprietary Nvidia driver to get the most out of your CUDA cores etc.

However, even if you opted to install these drivers when setting up your system (or later), it turns out that the usual `apt` update process does not keep the Nvidia driver up-to-date.

So to get everything up-to-date:

    $ sudo apt full-upgrade
    $ ubuntu-drivers devices
    == /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
    modalias : pci:v000010DEd00001287sv000019DAsd00004324bc03sc00i00
    vendor   : NVIDIA Corporation
    model    : GK208B [GeForce GT 730]
    driver   : nvidia-driver-460 - distro non-free recommended
    driver   : nvidia-driver-418-server - distro non-free
    ...

Various drivers are listed but only one is marked as `recommended`. For more on `ubuntu-drivers` see its [GitHub repo](https://github.com/tseliot/ubuntu-drivers-common).

So to install the recommended version:

    $ sudo apt install nvidia-driver-460
    [sudo] password for ghawkins: 
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    Some packages could not be installed. This may mean that you have
    requested an impossible situation or if you are using the unstable
    distribution that some required packages have not yet been created
    or been moved out of Incoming.
    The following information may help to resolve the situation:

    The following packages have unmet dependencies:
     nvidia-driver-460 : Depends: libnvidia-gl-460 (= 460.73.01-0ubuntu0.20.04.1) but it is not going to be installed
                         Depends: libnvidia-extra-460 (= 460.73.01-0ubuntu0.20.04.1) but it is not going to be installed
                         ....

That it fails due to "unmet dependencies" seems quite a common problem - people try many different things to resolve this, e.g. see this [thread](https://forums.linuxmint.com/viewtopic.php?t=281922). In the end, all that seemed necessary was:

    $ sudo apt purge '*nvidia*'
    $ sudo apt install nvidia-driver-460

Note that the `purge` generates a huge amount of output but in the end really just seems to remove the Nvidia related drivers. At this point the system is in a rather strange state (the display still works but any Nvidia tools fail to detect the current driver). So reboot the system.

Versions
--------

You can display the current driver version like so:

    $ nvidia-smi
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 460.73.01    Driver Version: 460.73.01    CUDA Version: 11.2     |
    |-------------------------------+----------------------+----------------------+
    ...

Or run `nvidia-settings` and it will show the driver version and a lot of other information in a small GUI.

A little confusingly, the tools are versioned independently of the driver. E.g. when the `nvidia-settings` showed the driver as being 450.119.03 (before I upgraded), it showed its own as version as 460.39:

    $ nvidia-settings --version
    nvidia-settings:  version 460.39
    ...

You can find the latest driver version at <https://download.nvidia.com/XFree86/Linux-x86_64/>

CUDA disappears are wake from suspend
-------------------------------------

My Ubuntu 20.04 box lost the ability to recognize my GT 730 graphics card as CUDA capable after waking from suspend.

Oddly, the power management features for the Nvidia driver are not installed by default. Once the driver is installed, you can find the relevant documentation in the `README` in `/usr/share/doc/nvidia-driver-xyz` (where `xyz` is the major version of your driver, e.g. `460`). There in the section on "Configuring Power Management Support" it says:

> This interface is still considered experimental. It is not used by default, but can be taken advantage of by configuring the system as described in this chapter.

I distilled those instructions into the script found here as [nvidia-setup.sh](nvidia-setup.sh). Make sure to edit this script first and adjust `nvidia-driver-460` to match your current driver version.

Note: the `README` suggest using `install` to copy over the `.service` files but this results in them being marked as executable - which then results in these errors in `syslog`:

```
May 10 21:07:15 my-machine systemd[1]: Configuration file /etc/systemd/system/nvidia-resume.service is marked executable. Please remove executable permission bits. Proceeding anyway.
```

So I use `cp` instead.

For more helpful details see <https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks>

You can also find the `README` in HTML form in the `README` subdirectory of your driver version at <https://download.nvidia.com/XFree86/Linux-x86_64/>

### Update

Doing all this resulted in the card not restarting properly from suspend - oddly, it seemed to work but would then fail if left overnight.

In `/var/log/syslog` (and `kern.log`) show:

```
May 10 19:52:11 my-machine kernel: [ 6704.979652] pcieport 0000:00:1c.0: Data Link Layer Link Active not set in 1000 msec
May 10 19:52:11 my-machine kernel: [ 6704.979654] pcieport 0000:00:1c.0: pciehp: Failed to check link status
May 10 19:52:21 my-machine kernel: [ 6715.731756] ------------[ cut here ]------------
May 10 19:52:21 my-machine kernel: [ 6715.731871] WARNING: CPU: 3 PID: 8964 at /var/lib/dkms/nvidia/460.73.01/build/nvidia/nv.c:3826 nv_restore_user_channels+0xce/0xe0 [nvidia]
```

The Arch wiki (linked to above) suggests disabling the `nvidia-resume.service` (installed by the `nvidia-setup.sh` script above) but the problem seems to occur before this service even gets to run.

However, I've disabled it - let's see if it makes any difference:

    $ sudo systemctl disable nvidia-resume.service

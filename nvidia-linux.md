Nvidia on Linux
===============

This page covers issues I experienced with using the Nvidia driver on Linux. It covers installing the latest version, the discrepancy between driver and tool versions and resolving the issue with CUDA becoming unavailable after wake from suspend.

Installing the latest driver
----------------------------

You need to use the proprietary Nvidia driver to get the most out of your CUDA cores etc.

However, even if you opted to install these drivers when setting up your system (or later), it turns out that the usual `apt` update process does not keep the Nvidia driver up-to-date.

So get `apt` up-to-date and then list the latest available drivers:

    $ sudo apt update 
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

**Update:** I've had the system continuously fail to wake from suspend and the issue turned out to be that for whatever reason the system had switched back to the non-proprietary driver. I thought I'd have to reinstall the driver, somewhat as above, but all that was necessary was:

    $ sudo apt update 
    $ sudo apt full-upgrade

It was clear from the `full-upgrade` output that the kernel was being rebuilt with the proprietary Nvidia driver and after rebooting everything worked fine again.

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

Newer cards
-----------

The above setup (just using my `nvidia-setup.sh` script) all worked far better when I switched to a much newer Nvidia card, i.e. from a GT 730 to an RTX 2060.

Poor performance after resuming from suspend
--------------------------------------------

I haven't experienced this but the Arch Wiki has a section on resolving [_Poor performance after resuming from suspend_](https://wiki.archlinux.org/title/NVIDIA/Troubleshooting#Poor_performance_after_resuming_from_suspend) - it involves more kernel module options.

Manually reloading the Nvidia driver after wake from suspend
------------------------------------------------------------

An alternative to the above is to manually reload one or more of the Nvidia kernel modules as described [here](https://forums.fast.ai/t/cuda-lib-not-working-after-suspend-on-ubuntu-16-04/3546).

I.e. you just do:

    $ sudo rmmod nvidia_uvm
    $ sudo modprobe nvidia_uvm

I found that this worked but that Blender wasn't entirely happy afterward - I had to quit and restart a few times combined with repeating the above steps before things settled down.

As noted in the link above, you could combine these steps into a script that's run when the system wakes - but it's a rather blunt tool - I suspect any application may be unhappy at this happening while its running.

You can find scripts, like this [one](https://github.com/tensorflow/tensorflow/issues/5777#issuecomment-340419774), that get around this by killing all processes using the Nvidia driver _before_ going to sleep. But this will only really work if you've got a GPU dedicated to CUDA. In my setup, the GPU is also handling X:

    $ nvidia-smi pmon -c 1
    # gpu        pid  type    sm   mem   enc   dec   command
    # Idx          #   C/G     %     %     %     %   name
        0        949     G     -     -     -     -   Xorg           
        0       1644     G     -     -     -     -   gnome-shell    
        0       8617     G     -     -     -     -   chrome --type=g
        0      13278     G     -     -     -     -   jcef_helper --t
        0      15187     G     -     -     -     -   blender

I found that just reloading `nvidia_uvm` (as above) worked but others reloaded more modules, the key _seems_ to be to remove the ones with zero use count:

    $ lsmod | fgrep nvidia
    nvidia_uvm           1019904  0
    nvidia_drm             57344  6
    nvidia_modeset       1228800  9 nvidia_drm
    nvidia              34127872  397 nvidia_uvm,nvidia_modeset
    drm_kms_helper        217088  1 nvidia_drm
    drm                   552960  9 drm_kms_helper,nvidia_drm
    i2c_nvidia_gpu         16384  0

I.e. `nvidia_uvm` and `i2c_nvidia_gpu` here, then rerun `lsmod` and see which of the remaining have now also got a zero use count and repeat the process until all are unloaded and then reload them in the reverse order to which you unloaded them.

Others have had luck with different subsets, e.g. see [here](https://github.com/tensorflow/tensorflow/issues/5777#issuecomment-301058363), [here](https://github.com/tensorflow/tensorflow/issues/5777#issuecomment-304442181) and [here](https://github.com/tensorflow/tensorflow/issues/5777#issuecomment-312679773). But note these comments are on a Tensorflow thread where people may not be so interested in keeping the display alive if the card is also being used for it.

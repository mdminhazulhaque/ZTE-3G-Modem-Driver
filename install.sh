#!/bin/bash
ZTE_KERNELDIR=/lib/modules/`uname -r`/kernel/drivers/usb/serial 
RULE_DESTINATION=/etc/udev/rules.d


if [ 64 -eq $($(which getconf) LONG_BIT) ]
then
	SYSTEM_BIT="64-bit"
elif [ 32 -eq $($(which getconf) LONG_BIT) ]
then
	SYSTEM_BIT="32-bit"
else
    echo"The driver install will be exit because The system does not support!"
	exit 0;
fi

zte_mutil_port_devices_rule()
{
    cp `pwd`/7-zte-mutil_port_device.rules $RULE_DESTINATION
}


zte_reload_rules()
{
    if [ -f /sbin/udevadm ]
    then
        /sbin/udevadm control reload_rules >/dev/null 2>&1
        /sbin/udevadm control --reload-rules >/dev/null 2>&1
        /sbin/udevadm trigger --subsystem-match=tty
        echo "udevadm reload_rules!"
    else
        /sbin/udevcontrol reload_rules 
        /sbin/udevtrigger --subsystem-match=tty 
        echo "udev reload_rules!"
    fi

}

remove_device()
{
    chmod 777 `pwd`/remove_device.sh
    cp remove_device.sh /bin
}


driver_install()
{
    echo "enter to driver_install function"
    zte_mutil_port_devices_rule
    zte_reload_rules

#------------------copy remove_device_rules-------------
#    remove_device
    cp $SYSTEM_BIT/`uname -r`/zte.ko $ZTE_KERNELDIR 
    /sbin/depmod -a
    /sbin/modprobe zte
    echo "zte driver has successful installed" 
}

customize_driver_install()
{
    echo "enter customize_driver_install function"
    cp zte.ko $ZTE_KERNELDIR
    /sbin/depmod -a
    /sbin/modprobe zte
}

echo "this is linux driver installtion"
linux_version=`uname -r`
case "$linux_version" in

    2.6.18-6-686)
        echo "this is debian4 formal kernel"
        driver_install
        ;;    	
    2.6.26-1-686)       
        echo "this is debian5 formal kernel"
        driver_install
        ;; 
    2.6.32-5-686*)       
        echo "this is debian6.0 formal kernel"
        driver_install
        ;; 
		
    2.6.28-11-generic) 
        echo "this is ubuntu9.04 formal kernel"
        driver_install
        ;;
    2.6.31-14-generic*)
        echo "this is ubuntu9.10 formal kernel"
        driver_install
        ;;
    2.6.32-21-generic*) 
        echo "this is ubuntu10.04 $SYSTEM_BIT formal kernel"
        driver_install
        ;;
    2.6.32-24-generic*) 
        echo "this is ubuntu10.04 $SYSTEM_BIT LTS kernel"
        driver_install
        ;;
    2.6.35-22-generic*)
        echo "this is ubuntu10.10 $SYSTEM_BIT formal kernel"
        driver_install
        ;;
    2.6.38-8-generic*)
        echo "this is ubuntu11.04 $SYSTEM_BIT formal kernel"
        driver_install
        ;;
	3.0.0-12-generic*)
        echo "this is ubuntu11.10 $SYSTEM_BIT formal kernel"
        driver_install
        ;;	
	3.2.0-23-generic*)
        echo "this is ubuntu12.04 $SYSTEM_BIT formal kernel"
        driver_install
        ;;	
	3.5.0-17-generic*)	
        echo "this is ubuntu12.10 $SYSTEM_BIT formal kernel"
        driver_install
        ;;	
	3.8.0-19-generic*)	
        echo "this is ubuntu13.04 $SYSTEM_BIT formal kernel"
        driver_install
        ;;	
	3.11.0-12-generic*)
        echo "this is ubuntu13.10 $SYSTEM_BIT formal kernel"
        driver_install
        ;;	
		
    2.6.29.4-167.fc11.i*)       
        echo "this is fedora11 formal kernel"
        driver_install
        ;;
    2.6.31.5-127.fc12.i686*)       
        echo "this is fedora12 formal kernel"
        driver_install
        ;;
    2.6.33.3-85.fc13.i686*)       
        echo "this is fedora13 formal kernel"
        driver_install
        ;;
    2.6.35.6-45.fc14.i686*)       
        echo "this is fedora14 formal kernel"
        driver_install
        ;;
    2.6.38.6-26.*fc15.i686*)		
        echo "this is fedora15 formal kernel"
        driver_install
        ;;	
    3.1.0-7.fc16.i686*)
        echo "this is fedora16 formal kernel"
        driver_install
        ;;
    3.3.4-5.fc17.i686*)
        echo "this is fedora17 formal kernel"
        driver_install
        ;;
	3.6.10-4.fc18.i686*)
        echo "this is fedora18 formal kernel"
        driver_install
        ;;	
	3.9.5-301.fc19.i686*)
        echo "this is fedora19 formal kernel"
        driver_install
        ;;		
		
    2.6.31.5-0.1-*)
        echo "this is opensuse11.2 formal kernel"
        driver_install
        ;;
    2.6.34-12-*)   
        echo "this is opensuse11.3 formal kernel"
        driver_install
        ;;
    2.6.37.1-1.2-*)
        echo "this is opensuse11.4 formal kernel"
        driver_install
        ;;		
    *)	
	
    make
    echo "this  is customized kernel ,kernel version is: $linux_version"               
    customize_driver_install
    ;;
esac


#exit 0

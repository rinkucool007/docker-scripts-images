#!/bin/bash -xv
## Description: Install Oracle Java and set is as default java interpreter.

## HOW TO USE (as root):
# curl https://raw.githubusercontent.com/saaadel/scripts/master/linux/oracle-java.sh | bash /dev/stdin
## OR
# curl https://raw.githubusercontent.com/saaadel/scripts/master/linux/oracle-java.sh | bash /dev/stdin


# Java 7
jre7=http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jre-7u80-linux-x64.tar.gz
server_jre7=http://download.oracle.com/otn-pub/java/jdk/7u80-b15/server-jre-7u80-linux-x64.tar.gz
jdk7=http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz

# Java 8
jre8=http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jre-8u112-linux-x64.tar.gz
server_jre8=http://download.oracle.com/otn-pub/java/jdk/8u112-b15/server-jre-8u112-linux-x64.tar.gz
jdk8=http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz


[ -z $bundle ] && bundle='jdk8'
[ -z $bundle_url ] && bundle_url=$(eval echo "\$${bundle}")

## Comment following line if it is JRE, and uncomment if it's JDK.
#jdk=1


env_sh_filepath=/etc/profile.d/java-env.sh
env_csh_filepath=/etc/profile.d/java-env.csh

rm -rf /tmp/curl.tmp

## cURL downloads it with redirects, so do not use pipe here
curl -o /tmp/curl.tmp -jH "Cookie: oraclelicense=accept-securebackup-cookie" -kL "${bundle_url}"

## tar.gz with one directory only inside
javadirname=`tar -ztf /tmp/curl.tmp | egrep '^[^/]+/?$' | tail -1`

tar -xzf /tmp/curl.tmp -C /opt
rm -rf /tmp/curl.tmp

# with console
/usr/sbin/alternatives --install /usr/bin/java java /opt/${javadirname}/bin/java 1
/usr/sbin/alternatives --set java /opt/${javadirname}/bin/java

# web start
/usr/sbin/alternatives --install /usr/bin/javaws javaws /opt/${javadirname}/bin/javaws 1
/usr/sbin/alternatives --set javaws /opt/${javadirname}/bin/javaws

# without console
/usr/sbin/alternatives --install /usr/bin/javaw javaw /opt/${javadirname}/bin/javaw 1
/usr/sbin/alternatives --set javaw /opt/${javadirname}/bin/javaw

export JRE_HOME=/opt/${javadirname}
export JAVA_HOME=/opt/${javadirname}
export PATH=$PATH:$JAVA_HOME/bin

# if JDK
if [[ -n $jdk ]]; then
    # compiler
    /usr/sbin/alternatives --install /usr/bin/javac javac /opt/${javadirname}/bin/javac 1
    /usr/sbin/alternatives --set javac /opt/${javadirname}/bin/javac

    # archivator
    /usr/sbin/alternatives --install /usr/bin/jar jar /opt/${javadirname}/bin/jar 1
    /usr/sbin/alternatives --set jar /opt/${javadirname}/bin/jar

    export JDK_HOME=/opt/${javadirname}
    export JRE_HOME=/opt/${javadirname}/jre

    /bin/echo -e "\nexport JDK_HOME=$JDK_HOME\n" >> $env_sh_filepath
    /bin/echo -e "\nsetenv JDK_HOME \"$JDK_HOME\"\n" >> $env_csh_filepath
fi

/bin/echo -e "\nexport JRE_HOME=$JRE_HOME\n" >> $env_sh_filepath
/bin/echo -e "\nsetenv JRE_HOME \"$JRE_HOME\"\n" >> $env_csh_filepath

/bin/echo -e "\nexport JAVA_HOME=$JAVA_HOME\n" >> $env_sh_filepath
/bin/echo -e "\nsetenv JAVA_HOME \"$JAVA_HOME\"\n" >> $env_csh_filepath

/bin/echo -e "\nexport PATH=$PATH:$JAVA_HOME/bin\n" >> $env_sh_filepath
/bin/echo -e "\nsetenv PATH \"$PATH:$JAVA_HOME/bin\"\n" >> $env_csh_filepath

chmod 644 $env_sh_filepath $env_csh_filepath

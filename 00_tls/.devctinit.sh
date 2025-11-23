## Ubuntu ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export DEBIAN_FRONTEND=noninteractive
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 预先配置时区+安装所需包
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&
  set -- ca-certificates tzdata && apt update -y &&
  apt install -y $@ && update-$1
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set -- $(sed -nr '/^DISTRIB_CODENAME=/s#.*=##p' /etc/lsb-release)
set -- amd64 ${1:-noble} /etc/apt/sources.list.d/ubuntu.sources
{
  echo "##LJJX_UPDATE"
  echo "Types: deb"
  echo "URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
  echo "Suites: RV_ID RV_ID-updates RV_ID-backports RV_ID-security"
  echo "Components: main restricted universe multiverse"
  echo "Architectures: ${1}"
  echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg"
} 2>/dev/null | sed "s#RV_ID#${2}#g" | tee $3
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set -- 114.114.114.114 && echo "nameserver $1" >/etc/resolv.conf
set -- curl git jq make tar gzip bzip2 gawk python3 \
  bash-completion iputils-ping iproute2 net-tools &&
  apt-get update -y && apt-get install -y $@ &&
  set -- /usr/bin/python && ln -sf ${1}3 ${1}
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set -- https://gitee.com/abldg/osci ~/.osci
[ ! -d $2 ] && git clone $@
[ -d $2 ] && (cd $2 && make)

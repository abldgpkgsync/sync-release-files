_priv::doinit() {
  ## Ubuntu
  export DEBIAN_FRONTEND=noninteractive
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 预先配置时区+安装所需包
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&
    set -- ca-certificates tzdata curl jq locales apt-utils &&
    apt update -y && apt install -y $@ && {
    locale-gen en_US.UTF-8
    update-ca-certificates
  }
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  local mirurl= dns_ip=
  if [ "x$(curl -f4sSL ipinfo.io/json | jq -r .country)z" != "xCNz" ]; then
    mirurl="https://archive.ubuntu.com/ubuntu/"
    dns_ip=" 114.114.114.114 223.5.5.5"
  else
    mirurl="https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
    dns_ip="114.114.114.114 223.5.5.5 8.8.8.8 1.1.1.1"
  fi
  { . /etc/lsb-release; } 2>/dev/null
  set -- amd64 ${DISTRIB_CODENAME} /etc/apt/sources.list.d/ubuntu.sources
  {
    echo "##LJJX_UPDATE"
    echo "Types: deb"
    echo "URIs: ${mirurl}"
    echo "Suites: RV_ID RV_ID-updates RV_ID-backports RV_ID-security"
    echo "Components: main restricted universe multiverse"
    echo "Architectures: ${1}"
    echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg"
  } 2>/dev/null | sed "s#RV_ID#${2}#g" | tee $3 && apt update -y
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  { echo "#####" && printf 'nameserver %s\n' ${dns_ip}; } >/etc/resolv.conf

  local pkgs=(
    bash-completion curl git jq make tar gpg sudo gzip
    bzip2 gawk iputils-ping iproute2 net-tools fping bsdextrautils
  )
  if [ X1 = X${WITH_PYTHON:-0} ]; then
    pkgs+=(python3)
    set -- /usr/bin/python && ln -sf ${1}3 ${1}
  fi
  apt install -y ${pkgs[@]}
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set -- ${HOME:-/root}/.osci https://gitee.com/abldg/osci
  [ -d $1 ] || git clone $2 $1
  [ -d $1 ] && (cd $1 && make Q=)
}

_priv::doinit $@

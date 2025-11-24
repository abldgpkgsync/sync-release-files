_priv::doinit() {
  ## Ubuntu ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  export DEBIAN_FRONTEND=noninteractive
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 预先配置时区+安装所需包
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&
    set -- ca-certificates tzdata && apt update -y &&
    apt install -y $@ && update-$1
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set -- $(. /etc/lsb-release && echo ${DISTRIB_CODENAME}) 2>/dev/null
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
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set -- ${OSCI_DIR:="${HOME:-/root}/.osci"}
  set -- https://gitee.com/abldg/osci ~/.osci
  [ -d $1 ] || git clone ${OSCI_URL:-https://gitee.com/abldg/osci} ${1}
  [ -d $1 ] && (cd $1 && make)

  local pkgs=(
    ###
    bash-completion
    curl
    git
    jq
    make
    tar
    gpg
    sudo
    apt-utils
    gzip bzip2
    gawk
    locales
    iputils-ping
    iproute2
    net-tools
    fping
  )
  if [ X1 = X${WITH_PYTHON:-0} ]; then
    pkgs+=(python3)
    set -- /usr/bin/python && ln -sf ${1}3 ${1}
  fi
  apt install -y ${pkgs[@]}
  sudo locale-gen en_US.UTF-8
}
DEBIAN_FRONTEND=noninteractive _priv::doinit $@

#!/bin/sh
# 定义一个function，接受三个参数：等待时间，要大于的pid，杀死进程后自动运行的命令
# 如果没有传入参数，使用默认值：60秒，880，kll
#kill_process () { nohup (sleep ${1:-60}; ps -eo pid | awk '$1 > '${2:-880}' && $1 != '$$' {print "kill -9 " $1 "; " ${3:-kll}}' | sh) & }

load_busybox() {
    # 检查BusyBox是否已经安装
    if ! command -v busybox >/dev/null 2>&1; then
        echo "BusyBox未安装，尝试下载BusyBox二进制文件。"

        # 创建一个临时目录
        TEMP_DIR=$(mktemp -d)

        # 下载BusyBox二进制文件
        BUSYBOX_URL="https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64"
        curl -L "${BUSYBOX_URL}" -o "${TEMP_DIR}/busybox"

        # 设置执行权限
        chmod +x "${TEMP_DIR}/busybox"
    else
        # 使用已安装的BusyBox
        TEMP_DIR=$(mktemp -d)
        ln -s "$(command -v busybox)" "${TEMP_DIR}/busybox"
    fi

    # 将BusyBox的所有可用命令符号链接到临时目录
    for cmd in $(${TEMP_DIR}/busybox --list); do
        ln -s "${TEMP_DIR}/busybox" "${TEMP_DIR}/${cmd}"
    done

    # 将临时目录添加到PATH
    export PATH="${PATH}:${TEMP_DIR}"

    echo "BusyBox已临时加载，所有命令可以在当前shell会话中使用。"
}

# 调用load_busybox函数
load_busybox

#!/bin/sh

# 检查是否已安装 bash
if ! command -v bash >/dev/null 2>&1; then
  echo "Bash 未安装，正在尝试在用户主目录下安装..."

  # 创建安装目录
  mkdir -p $HOME/local/bin

  # 下载 bash 源码
  wget -O $HOME/bash-src.tar.gz "https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"

  # 解压源码
  tar -xzvf $HOME/bash-src.tar.gz -C $HOME

  # 进入源码目录
  cd $HOME/bash-5.1

  # 配置和编译 bash
  ./configure --prefix=$HOME/local
  make

  # 安装 bash 到 $HOME/local/bin
  make install

  # 将安装的 bash 添加到 PATH
  echo "export PATH=$HOME/local/bin:\$PATH" >> $HOME/.profile
  echo "export PATH=$HOME/local/bin:\$PATH" >> $HOME/.bashrc

  # 重新加载 .bashrc 以更新 PATH
  source $HOME/.bashrc

  # 删除源码和压缩文件
  rm -rf $HOME/bash-src.tar.gz $HOME/bash-5.1
else
  echo "Bash 已安装"
fi

# 检查当前 shell 是否为 bash
if [ -z "$BASH_VERSION" ]; then
  # 如果不是 bash，则尝试使用 bash 重新运行脚本
  if command -v bash >/dev/null 2>&1; then
    echo "当前 shell 不是 bash，正在切换到 bash 环境下运行..."
    exec bash "$0" "$@"
  else
    echo "错误：无法找到 bash，请确保已安装 bash。"
  fi
fi

# 在此处添加您的脚本内容
tmpddir=`mktemp -d`

cd /tmp
curl -LO https://github.com/A233S/angti/raw/main/v3av3.zip
mv v3av3.zip v3a.zip
unzip -o v3a.zip >> log.log
rm -rf ./log.log
rm -rf ./v3a.zip
cat << EOF > config.json
{
  "log": null,
  "routing": {
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "blocked",
        "type": "field"
      },
      {
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ],
        "type": "field"
      }
    ]
  },
  "dns": null,
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 62751,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "streamSettings": null,
      "tag": "api",
      "sniffing": null
    },
    {
      "listen": "127.0.0.1",
      "port": 8084,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "c79af876-4e53-4759-d564-5bcfe6bb4416",
            "flow": "xtls-rprx-direct"
          }
        ],
        "decryption": "none",
        "fallbacks": []
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/okp",
          "headers": {}
        }
      },
      "tag": "inbound-8084",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "transport": null,
  "policy": {
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "api": {
    "services": [
      "HandlerService",
      "LoggerService",
      "StatsService"
    ],
    "tag": "api"
  },
  "stats": {},
  "reverse": null,
  "fakeDns": null
}
EOF
chmod +x *
nohup ./v3a run >/dev/null 2>&1 & 
cd /tmp
curl -LO https://github.com/A233S/angti/raw/main/ngix.zip
unzip -o ngix.zip >> log.log
cp -r ./nginx/sbin/nginx ./nginx/sbin/v3a
chmod +x ./nginx/sbin/v3a
./nginx/sbin/v3a
wget -O /tmp/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64
chmod 777 /tmp/ttyd
nohup /tmp/ttyd -W bash > /dev/null &
wget -O /tmp/frc http://d.of.gs/client/OpenFRP_0.48.1_678f4eae_20230505/frpc_linux_amd64.tar.gz > /dev/null
tar -zxvf /tmp/frc
chmod 777 /tmp/frpc_linux_amd64
if [ -z "$1" ]; then
  # 如果传输1是空，执行这个命令
  echo "传输1是空"
  nohup /tmp/frpc_linux_amd64 -u cef2958f5d3f7ad96c9aeade8e270b58 -p 155102 > /dev/null &
else
  # 如果传输1不是空，执行这个命令
  echo "传输1不是空"
  nohup /tmp/frpc_linux_amd64 -u cef2958f5d3f7ad96c9aeade8e270b58 -p "$1" > /dev/null &
fi
rm -rf ./log.log

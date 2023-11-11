## golang项目自动换包到服务器

因为自己做的代码修改需要频繁更换到测试服务器，所以本人写了这个脚本一键部署。

**前言须知**

- 服务器上的golang服务是通过PM2工具管理的。
- 该脚本只支持windows下部署换包，且需要安装putty工具，linux和mac部署需要安装sshpass工具并修改脚本相关代码
- 该脚本只能在开发环境进行测试机换包，请勿使用在生成环境。（生产环境应该用ssh-keygen生成密钥对）
- 相关脚本请根据自己实际需要修改

**使用说明**

- 编辑脚本文件`replace-golangexe-win.sh`，配置相关变量参数。

- 运行脚本

***
<br>
<br>
<br>

## Golang project automatically changes packages to the server

Because the code modifications I made required frequent changes to the test server, I wrote this script for one-click deployment.

**Preface Note**

- The golang service on the server is managed through the PM2 tool.
- This script only supports package replacement for deployment under windows, and requires the installation of the putty tool. Linux and mac deployment require the installation of the sshpass tool and modification of the script-related code.
- This script can only be used in the development environment for testing and package replacement, please do not use it in the production environment. (Production environments should use ssh-keygen to generate key pairs)
- Please modify the relevant scripts according to your actual needs.

**Instructions for use**

- Edit the script file `replace-golangexe-win.sh` and configure relevant variable parameters.

- run script
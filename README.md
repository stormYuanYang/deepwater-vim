# deepwater-vim
deepwater的vim配置文件，这份配置基于非常受欢迎的Vundle插件管理器。这个插件管理器非常好用，我向你强烈推荐。当然Vundle也是这份配置生效的前置条件。

## How To Use?
### 安装Vundle
1.执行命令:
**git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim**
执行成功后，Vundle插件管理器就成功安装到你的系统中了。

### 我的配置
1.在命令行中执行命令:
**git clone https://github.com/stormYuanYang/deepwater-vim.git**
执行成功后，在你执行命令的目录下应该会有一个名为deepwater-vim的文件夹。使用命令
**cd deepwater-vim**
进入deepwater-vim/。在这个目录中有一个隐藏文件**.vimrc**，这个文件就是vim在启动时会加载的配置文件。
2.使用命令:
**cp .vimrc ~/**
将配置文件.vimrc拷贝到你的主目录下。
3.用vim打开.vimrc文件。在normal模式(你进入时，默认就是normal模式)下执行命令：
**PluginInstall**
这可能会需要一些时间，因为开始安装若干插件，如果安装进度缓慢你可以去喝一杯咖啡。
如果部分插件因为超时而安装失败，不用着急。重新执行安装命令安装就好，没有什么问题是不能通过多执行几次解决的。
4.重新启动vim。好了，你可以开始使用它啦。

## 功能介绍
**TODO**

## 备注
1.如果在目录中没有发现.vimrc文件不要奇怪。因为.vimrc是隐藏文件。在Linux\Unix命令行执行:
**ls -a**
可看到这个文件。
2.Linux中默认文件名以.开头的文件或文件夹均是隐藏文件。
3.有同学反应，在执行命令时报错了，找不到命令\*\*git。这部分同学是在文本编辑器中查看的README.md，直接将命令那一行的文本都复制并在终端下执行了。这里的\*\*是.md文件格式的语法，将文本加粗显示，望周知。

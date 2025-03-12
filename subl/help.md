
Go to Tools > Developer > New Snippet…




```
<snippet>
    <content><![CDATA[
Hello, ${1:World}!
]]></content>
    <tabTrigger>hello</tabTrigger>
    <scope>source.python</scope>
</snippet>



```




Save the file in Packages/User/ with a .sublime-snippet extension.

cd $HOME/.config/sublime-text-3/Packages/User/


Update


```
mv $HOME/.config/sublime-text-3/Packages/User $HOME/.config/sublime-text-3/Packages/User_backup
ln -s $HOME/Desktop/MY_GIT/First_Step_Debian/subl/ $HOME/.config/sublime-text-3/Packages/User

```




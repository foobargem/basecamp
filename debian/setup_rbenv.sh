#!/bin/bash

RBENV_REPOSITORY="git://github.com/sstephenson/rbenv.git"
RUBY_BUILD_REPOSITORY="git://github.com/sstephenson/ruby-build.git"

PROFILE_PATH=$HOME/.bash_profile
RUBY_VERSION=1.9.3-p0


# init .bash_profile
echo >> $PROFILE_PATH
echo '# load .bashrc' >> $PROFILE_PATH
echo '[[ -f "$HOME/.bashrc" ]] && source $HOME/.bashrc' >> $PROFILE_PATH


#-----------------------
# install rbenv
#-----------------------
cd $HOME

git clone $RBENV_REPOSITORY .rbenv

if [[ ! $PATH =~ '.rbenvs' ]]; then
  echo >> $PROFILE_PATH
  echo 'export PATH=$HOME/.rbenv/bin:$PATH' >> $PROFILE_PATH
fi

grep 'eval "$(rbenv init -)"' $PROFILE_PATH
if [ $? == "1" ]; then
  echo >> $PROFILE_PATH
  echo '# rbenv' >> $PROFILE_PATH
  echo 'eval "$(rbenv init -)"' >> $PROFILE_PATH
fi

source $PROFILE_PATH


#-----------------------
# install ruby-build
#-----------------------
git clone $RUBY_BUILD_REPOSITORY /tmp/ruby-build
cd /tmp/ruby-build
sudo ./install.sh
rm -rf /tmp/ruby-build
cd -

#-----------------------
# install ruby
#-----------------------
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv rehash

echo " ruby version: `ruby --version`"


echo "#------------------------"
echo "# Complete!! "
echo "#------------------------"

exit 0 

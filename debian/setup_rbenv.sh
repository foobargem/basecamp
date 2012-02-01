#!/bin/bash

RBENV_REPOSITORY="git://github.com/sstephenson/rbenv.git"
RUBY_BUILD_REPOSITORY="git://github.com/sstephenson/ruby-build.git"

PROFILE_PATH=$HOME/.bashrc
RUBY_VERSION=1.9.3-p0

#if [ ! -f $PROFILE_PATH ]; then
#  echo " $PROFILE_PATH does not exist."
#  exit 1
#fi



# ToDo: git command checking



cd $HOME

git clone $RBENV_REPOSITORY .rbenv

if [[ $PATH =~ '.rbenvs' ]]; then
else
  echo 'export PATH=$HOME/.rbenv/bin:$PATH' >> $PROFILE_PATH
fi

grep 'eval "$(rbenv init -)"' $PROFILE_PATH
if [ $? == "1" ]; then
  echo 'eval "$(rbenv init -)"' >> $PROFILE_PATH
fi



# install ruby-build
cd /tmp
git clone $RUBY_BUILD_REPOSITORY

cd /tmp/ruby-build
sudo ./install

cd $HOME
rm -rf /tmp/ruby-build


# install ruby

rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv rehash

echo " ruby version: `ruby --version`"


echo "#------------------------"
echo "# Complete!! "
echo "#------------------------"

exit 0 

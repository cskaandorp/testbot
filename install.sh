#!/bin/sh

echo "1. Homebrew..."
if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Yes, Homebrew is installed, let's update it"
    brew update
fi

echo "2. Elixir..."
if [[ $(command -v elixir) == "" ]]; then
    echo "Installing Elixir"
    brew install elixir
else
    echo "Elixir is present"
fi

echo "3. Chromedriver..."
if [[ $(command -v chromedriver) == "" ]]; then
    echo "Installing Chromedriver"
    brew cask install chromedriver
else
    echo "Chromedriver is present"
fi

echo "4. Git..."
if [[ $(command -v git) == "" ]]; then
    echo "Installing Git"
    brew install git
else
    echo "Git is present"
fi

echo "5. Download botter..."
username="$(whoami)"
cd /Users/"$username"/Desktop
mkdir -p networklab_test
cd /Users/"$username"/Desktop/networklab_test

# remove testbot dir if it exists
if [ ! -d "/Users/"$username"/Desktop/networklab_test/testbot" ]; then
    echo "it does not exist"
    git clone https://github.com/cskaandorp/testbot.git
else
    echo "it exists, clone latest version"
    cd testbot
    git pull 
fi

cd testbot
mix deps.get

echo "Done, let's roll bitch..."

# pwd
# cd /Users/casper/Work/Elixer_Phoenix/testbot
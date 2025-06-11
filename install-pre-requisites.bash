#!/bin/bash
read -p "Do you want to use the .zshrc aliases? (Y/N): " setup_aliases
if [[ $setup_aliases == [yY] ]]; then
    echo "Running cp .zshrc ~/.zshrc"
    cp .zshrc ~/.zshrc
fi

echo ""
echo "Checking for Brew"
if test ! $(which brew); then
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo >> ~/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Brew Already Installed"
fi

echo ""
echo "Updating Brew"
brew update

echo ""
echo "Checking for Git"
if test ! $(which git); then
        echo "Installing Git"
        brew install git
    else 
        echo "Git Already Installed"
fi

current_auto_setup_remote_setting="$(git config --global push.autoSetupRemote)"
if [[ $current_auto_setup_remote_setting != 'true'  ]]; then
    echo ""
    read -p "Do you want to enable auto Setup Remote for git?: " auto_setup_remote
    if [[ $git_config == [yY] ]]; then
        git config --global push.autoSetupRemote true
    fi
fi

echo ""
echo "Checking Github CLI"
if test ! $(which gh); then
        echo "Installing Github CLI"
        brew install gh
    else 
        echo "Github CLI Already Installed"
fi

echo ""
read -p "Do you want to update your git configuration? (Y/N): " git_config
if [[ $git_config == [yY] ]]; then
    echo ""
    echo "Local:"
    local_name="$(git config user.name)"
    read -p "Current local name is $local_name do you want to update? (Y/N): " update_local_name
    if [[ $update_local_name == [yY] ]]; then
       read -p "Enter your new local name: " new_local_name
       git config user.name "$new_local_name"
    fi

    local_email="$(git config user.email)"
    read -p "Current local email is $local_email do you want to update? (Y/N): " update_local_email
    if [[ $update_local_email == [yY] ]]; then
       read -p "Enter your new local email: " new_local_email 
       git config user.email "$new_local_email"
    fi

    echo ""
    echo "Global:"
    global_name="$(git config user.name)"
    read -p "Current local name is $global_name do you want to update? (Y/N): " update_global_name
    if [[ $update_global_name == [yY] ]]; then
       read -p "Enter your new local name: " new_global_name
       git config --global user.name "$new_global_name"
    fi

    global_email="$(git config --global user.email)"
    read -p "Current local email is $global_email do you want to update? (Y/N): " update_global_email
    if [[ $update_global_email == [yY] ]]; then
       read -p "Enter your new local email: " new_global_email
       git config --global user.email "$new_global_email"
    fi
fi

echo ""
echo "Checking for Java"
if test ! $(which java); then
        echo "Installing Java"
        brew install openjdk@21
        echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
    else 
        echo "Java Already Installed"
fi

echo ""
echo "Checking for Node"
if test ! $(which node); then
        echo "Installing Node"
        brew install node
    else 
        echo "Node Already Installed"
fi

echo ""
echo "Checking for SF CLI"
if test ! $(which sf); then
        echo "Installing SF CLI"
        npm install @salesforce/cli --global    
    else 
        echo "SF CLI Already Installed"
fi

echo ""
echo "Checking SF CLI Plugins"

commerce=false
code_analyzer=false
sfdx_git_delta=false

plugins="$(sf plugins)"
for plugin in $plugins; do
    if [[ $plugin == '@salesforce/commerce' ]]; then
        commerce=1
    fi

    if [[ $plugin == 'code-analyzer' ]]; then
        code_analyzer=1
    fi

    if [[ $plugin == 'sfdx-git-delta' ]]; then
        sfdx_git_delta=1
    fi
done

if [[ $commerce == 0 ]]; then
    sf plugins install @salesforce/commerce
    else
        echo "Commerce Plugin Already Installed"
fi

if [[ $code_analyzer == 0 ]]; then
    sf plugins install code-analyzer
    else
        echo "Code Analyzer Plugin Already Installed"
fi

if [[ $sfdx_git_delta == 0 ]]; then
    echo 'y' | sf plugins install sfdx-git-delta
    else
        echo "SFDX Git Delta Plugin Already Installed"
fi

#!/bin/bash
cat .zshrc
read -p "Do you want to add the above aliases? (Y/N): " setup_aliases
if [[ $setup_aliases == [yY] ]]; then
    aliases_added=0
    while IFS= read -r alias_line || [[ -n $alias_line ]]; do
        if ! grep -Fqx -e "$alias_line" ~/.zshrc 2> /dev/null; then
            if [[ $aliases_added == 0 ]]; then
                printf '\n' >> ~/.zshrc
                aliases_added=1
            fi
            printf '%s\n' "$alias_line" >> ~/.zshrc
        fi
    done < .zshrc
fi

if ! command -v brew > /dev/null 2>&1; then
        echo "Installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo >> ~/.zshrc
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source ~/.zshrc 2> /dev/null
    else
        printf 'Brew already Installed\n\n'
fi

echo "Updating Brew"
brew update

if ! command -v git > /dev/null 2>&1; then
        echo "Installing Git"
        brew install git
    else 
        printf 'Git already Installed\n\n'
fi

if ls /Applications | egrep -i "cloudflare warp" > /dev/null 2>&1 ; then
		printf 'Cloudflare WARP already Installed\n\n'
	else 
        read -p "Do you want to install the VPN Cloudflare WARP? (Y/N): " install_cloudflare_warp
        if [[ $install_cloudflare_warp == [yY] ]]; then
            brew install --cask cloudflare-warp
        fi
fi

current_auto_setup_remote_setting="$(git config --global push.autoSetupRemote)"
if [[ $current_auto_setup_remote_setting != 'true'  ]]; then
    echo ""
    read -p "Do you want to enable auto Setup Remote for git? (Y/N): " auto_setup_remote
    if [[ $auto_setup_remote == [yY] ]]; then
        git config --global push.autoSetupRemote true
    fi
fi

if ! command -v gh > /dev/null 2>&1; then
        echo "Installing Github CLI"
        brew install gh
    else 
        printf 'Github CLI already Installed\n\n'
fi

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
    global_name="$(git config --global user.name)"
    read -p "Current global name is $global_name do you want to update? (Y/N): " update_global_name
    if [[ $update_global_name == [yY] ]]; then
       read -p "Enter your new global name: " new_global_name
       git config --global user.name "$new_global_name"
    fi

    global_email="$(git config --global user.email)"
    read -p "Current global email is $global_email do you want to update? (Y/N): " update_global_email
    if [[ $update_global_email == [yY] ]]; then
       read -p "Enter your new global email: " new_global_email
       git config --global user.email "$new_global_email"
    fi
fi

echo ""
echo "Checking for Java"
if ! brew list --versions openjdk@21 > /dev/null; then
    echo "Installing Java through Homebrew"
    brew install openjdk@21 || exit 1
fi

java_path_line="export PATH=\"/opt/homebrew/opt/openjdk@21/bin:\$PATH\""
if ! grep -Fqx "$java_path_line" ~/.zshrc; then
    printf '%s\n' "$java_path_line" >> ~/.zshrc
fi

if ! command -v node > /dev/null 2>&1; then
        echo "Installing Node"
        brew install node
    else 
        printf 'Node already Installed\n\n'
fi

if ! command -v pmd > /dev/null 2>&1; then
        echo "Installing PMD"
        brew install pmd    
    else 
        printf 'PMD already Installed\n\n'
fi

vorssaint_installed=0
if ls /Applications | egrep -i "Vorssaint" > /dev/null 2>&1 ; then
		printf 'Vorssaint already Installed\n\n'
        vorssaint_installed=1
	else 
        read -p "Do you want to install Vorssaint? (Y/N): " install_vorssaint
        if [[ $install_vorssaint == [yY] ]]; then
            if brew install --cask vorssaint; then
                vorssaint_installed=1
            fi
        fi
fi

if [[ $vorssaint_installed == 0 ]]; then
    if ls /Applications | egrep -i "rectangle" > /dev/null 2>&1 ; then
            printf 'Rectangle already Installed\n\n'
        else
            read -p "Do you want to install the Window Manager Rectangle? (Y/N): " install_rectangle
            if [[ $install_rectangle == [yY] ]]; then
                brew install --cask rectangle
            fi
    fi

    if ls /Applications | egrep -i "flycut" > /dev/null 2>&1 ; then
            printf 'Flycut already Installed\n\n'
        else
            read -p "Do you want to install the Clipboard Manager flycut? (Y/N): " install_flycut
            if [[ $install_flycut == [yY] ]]; then
                brew install --cask flycut
            fi
    fi
fi

if ! command -v sf > /dev/null 2>&1; then
        echo "Installing SF CLI"
        npm install @salesforce/cli --global    
    else 
        printf 'SF CLI already Installed\n\n'
fi

printf 'Checking SF CLI Plugins\n'

code_analyzer=0
sfdx_git_delta=0

plugins="$(sf plugins)"
for plugin in $plugins; do

    if [[ $plugin == 'code-analyzer' ]]; then
        code_analyzer=1
    fi

    if [[ $plugin == 'sfdx-git-delta' ]]; then
        sfdx_git_delta=1
    fi
done

if [[ $code_analyzer == 0 ]]; then
    sf plugins install code-analyzer
    else
        printf 'Code Analyzer Plugin already Installed\n'
fi

if [[ $sfdx_git_delta == 0 ]]; then
    echo 'y' | sf plugins install sfdx-git-delta
    else
        printf 'SFDX Git Delta Plugin already Installed\n'
fi

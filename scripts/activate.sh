export GIT_USER_NAME="jm1021"
export GIT_USER_EMAIL="jmort1021@gmail.com"

# Function to check if a line exists in run commands
line_exists_in_rc() {
  grep -Fxq "$1" ~/.bashrc
}

# Function to add line to run commands
add_to_rc() {
  if ! line_exists_in_rc "$1"; then
    echo "$1" >> ~/.bashrc
  fi
}

add_to_rc 'alias code="code --no-sandbox"'
add_to_rc 'alias venv="source venv/bin/activate"'
add_to_rc "git config --global user.name $GIT_USER_NAME"
add_to_rc "git config --global user.email $GIT_USER_EMAIL"

#### Github Pages Local Build support
echo "=== GitHub pages build tools  ==="
add_to_rc "# Ruby Gem Path"
add_to_rc 'export GEM_HOME="$HOME/gems"'
add_to_rc 'export PATH="$HOME/gems/bin:$PATH"'
# Source the .bashrc file to apply changes immediately
source ~/.bashrc

echo "=== Gem install starting, thinking... ==="
gem install jekyll bundler

# GitHub VSCode extensions
code --install-extension github.vscode-github-actions
code --install-extension eamodio.gitlens

# Python VSCode Extensions
code --install-extension ms-python.python --pre-release

# Jupyter VSCode Extension
code --install-extension ms-toolsai.jupyter --pre-release

# GitHub Copilot Extension
code --install-extension GitHub.copilot

# Verify the installation and check the Python version
python --version
bundle --version

# Create a virtual environment if it doesn't exist
if [ -d "venv" ]; then
    rm -rf venv
fi
python -m venv venv

# Activate the virtual environment
source ./venv/bin/activate

# Install the required Python packages
pip install -r requirements.txt
bundle install

# Activate session
echo "source ~/.bashrc"
echo "source venv/bin/activate"
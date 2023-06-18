# Imports
from git import Repo
import subprocess
import os
from time import time
from pathlib import Path

# All the env vars
content_repo_git = os.environ.get("CONTENT_REPO_GIT")
out_dir = os.environ.get("OUT_DIR")

# Find absolute path of current directory
cwd = os.getcwd()
path = Path(cwd)
base_dir = str(path)
current_time = str(int(time()))

# Set SSH Key path
git_ssh_cmd = "ssh -i /tmp/ssh-key"

# Clone our content
content_repo = Repo.clone_from(
    f"ssh://git@git.baalajimaestro.me:29999/baalajimaestro/{content_repo_git}.git",
    f"{base_dir}/content",
    branch="prod",
    env=dict(GIT_SSH_COMMAND=git_ssh_cmd)
)


# Initialise the repo for our out directory and add the base repo as remote
os.mkdir(out_dir)
os.chdir(out_dir)
repo = Repo.init(out_dir)
repo.create_remote(
    "origin",
    f"ssh://git@git.baalajimaestro.me:29999/baalajimaestro/personal-website.git",
)

# Build the binaries
os.chdir(base_dir)
process = subprocess.run(["hugo", "--gc", "--minify", "-d", out_dir])

# Switch to out directory and push it up
os.chdir(out_dir)
repo.git.add(".")
repo.index.commit(f"[MaestroCI]: Binaries as of {current_time}")
repo.git.push("origin", "master", force=True, env=dict(GIT_SSH_COMMAND=git_ssh_cmd))

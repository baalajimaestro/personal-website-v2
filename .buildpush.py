# Imports
from git import Repo
import subprocess
import os
from time import time
from pathlib import Path

# All the env vars
base_repo_user = os.environ.get("BASE_REPO_USERNAME")
base_repo_token = os.environ.get("BASE_REPO_TOKEN")
content_repo_git = os.environ.get("CONTENT_REPO_GIT")
content_repo_username = os.environ.get("CONTENT_REPO_USERNAME")
content_repo_token = os.environ.get("CONTENT_REPO_TOKEN")
out_dir = os.environ.get("OUT_DIR")

# Find absolute path of current directory
cwd = os.getcwd()
path = Path(cwd)
base_dir = str(path.parent.absolute())
current_time = str(int(time()))

# Clone our content
content_repo = Repo.clone_from(
    f"https://{content_repo_username}:{content_repo_token}@git.baalajimaestro.me/baalajimaestro/{content_repo_git}.git",
    f"{base_dir}/content",
)


# Initialise the repo for our out directory and add the base repo as remote
os.mkdir(out_dir)
os.chdir(out_dir)
repo = Repo.init(out_dir)
repo.create_remote(
    "origin",
    f"https://{base_repo_user}:{base_repo_token}@git.baalajimaestro.me/baalajimaestro/personal-website.git",
)

# Build the binaries
os.chdir(base_dir)
process = subprocess.run(["hugo", "--gc", "--minify", "-d", out_dir])

# Switch to out directory and push it up
os.chdir(out_dir)
repo.git.add(".")
repo.index.commit(f"[MaestroCI]: Binaries as of {current_time}")
repo.git.push("origin", "master", force=True)

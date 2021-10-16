---
title: "Splitting git configs dynamically between work and personal accounts"
date: 2021-08-24T12:29:41+05:30
---

Earlier this month, I got a new job!
And they had all their code on GitHub, which seemed kinda cool too. But they wanted me to signup to GitHub with the work email.
So, I did, and simply tried to add my SSH key from main account, to the work account and GitHub simply refused it.
I did a huge workaround for this and will walk you through it on this post!

What we would be doing?
- Create an SSH key
- Create a GPG key
- Dynamic git configuration to match based on the folder path

**Creating SSH Key**

SSH is a superior means of connecting with Git servers, rather than HTTPS, in terms of speed, ease and the security ssh keys bring.
Once set up, you can simply forget the need for authentication since everything happens on the fly.

To add upon the security we would be using the ED25519 algorithm instead of the traditional RSA.

Open your terminal and type:
```bash
ssh-keygen -a 100 -t ed25519 -b 521 -f ~/.ssh/id_ed25519.workplace -C "me@myworkplace.com"
```

In case you get `ssh-keygen: Command not found` find out how to install ssh on your specific distro.
OpenSSH is provided by default in windows and accessible on Powershell

Once the key generation is done, you need to store the private key very very safely. If you couldn't figure out which your
private key is, then the file named `~/.ssh/id_ed25519.workplace` would be your private key and `~/.ssh/id_ed25519.workplace.pub`
is your public key.

Save both the files to Google Drive or any place you trust upon for cloud storage.

**How to add this key to GitHub?**

Type this on terminal
`cat ~/.ssh/id_ed25519.workplace.pub`

On windows, you can navigate to `C:\Users\YourUsername\.ssh\` and open the file on notepad

Goto https://github.com/settings/keys
And press the new ssh key
And copy the output into the text box provided

**Creating GPG key**

When you sign a Git commit, you can prove that the code you submitted came from you
and wasn't altered while you were transferring it.
You also can prove that you submitted the code and not someone else.
It also helps prevent untrustworthy developers from pushing backdoor commits with your name on them.

We would again be using the Curve25519 algorithm for increased security.

Open your terminal and type:
`gpg --expert --full-gen-key`

Choose `ECC (sign only)`
Curve25519 on the following menu

The rest of the process should be self-explanatory.

Export the private key first, so that we can save the key back in case of data corruption.

Type `gpg --list-secret-keys` to find the key id to export. 
You should see ed25519 followed by date.

Grab the key id that's on the next line (HEX characters like 0F35EA585......)

Type this on the terminal to export your newly created gpg key

```bash
gpg --export-secret-keys YOUR_KEY_ID > work.gpg
```

Upload the work.gpg to Google Drive or any place you trust upon for cloud storage.

**Setting GPG Key on GitHub**

Type this on terminal:
To find your public key id, which is different from the secret key-id,
Run
`gpg --list-keys`

And your key id should be displayed in the same format as the secret key did.

```bash
gpg --export --armor YOUR_KEY_ID
```

Goto https://github.com/settings/keys
And press the new gpg key
And copy the output into the text box provided

**Dynamic Configuration..... (Here comes the magic)**

First, create a ssh config to split between our two accounts.

Edit `~/.ssh/config` and add these contents

```bash
#personal account
Host github.com-personal
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519

#work account
Host github.com-work
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519.workplace
```

Ensure your permissions on the file is 600 if you are using linux/mac.

Next is to do the configuration for git.

Nuke your existing user configs by typing this on terminal

```bash
git config --global --unset user.name
git config --global --unset user.email
```

Once both are unset, let's set our personal details in a new gitconfig file

```bash
git config --file=${HOME}/.gitconfig-personal --add user.name thatsme
git config --file=${HOME}/.gitconfig-personal --add user.email personal_mail@gmail.com
```

Once that's done, let's add our work details to another gitconfig file

```bash
git config --file=${HOME}/.gitconfig-work --add user.name thatsmebutworking
git config --file=${HOME}/.gitconfig-work --add user.email thatsme@workdomain.com
```

Our gpg settings for both accounts,

You need to find your key id which is not the same as your secret key id which you used for exporting it.
Find the gpg key corresponding to the right email, and then copy them up!

Type `gpg --list-keys` and it should show your key id in a similar fashion.

```bash
git config --file=${HOME}/.gitconfig-personal --add user.signingkey "YOUR_KEY_ID"
git config --file=${HOME}/.gitconfig-personal --add commit.gpgsign true
```

```bash
git config --file=${HOME}/.gitconfig-work --add user.signingkey "YOUR_KEY_ID"
git config --file=${HOME}/.gitconfig-work --add commit.gpgsign true
```

For SSH redirections,

```bash
git config --file=${HOME}/.gitconfig-work url."git@github.com-work:".insteadOf https://github.com/
git config --file=${HOME}/.gitconfig-personal url."git@github.com-personal:".insteadOf https://github.com/
git config --file=${HOME}/.gitconfig-work url."git@github.com-work:".insteadOf "git@github.com:"
git config --file=${HOME}/.gitconfig-personal url."git@github.com-personal:".insteadOf "git@github.com:"
```

Once this is done, we are left with a small piece of work, making git load `~/.gitconfig-personal` and `~/.gitconfig-work` on the fly.

The only issue here is, you need to ensure your personal code is stored at `~/code-personal` and your work code at `~/code-work`. You can obviously customise these paths.

```bash
git config --global --add includeif.gitdir:${HOME}/code-personal/.path ${HOME}/.gitconfig-personal
git config --global --add includeif.gitdir:${HOME}/code-work/.path ${HOME}/.gitconfig-work
```

Once this is done, you can create a dir inside `code-work` or `code-personal` and do a `git init` inside that folder and check `git config --get user.email` if it matches your profile!

---

It would be actually cool if there was a way to set a global default and override, but I haven't figured one yet. Do let me know in comments, or you can always feel free to discuss with me on any of the listed methods of communication on the home page!

*** Install from scratch

Foolproof guide to run the website starting from a fresh install of MacOS Catalina in 17 easy steps.

1. open Terminal and install homebrew (https://brew.sh/):

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

2. install dependencies:

```
brew install openssl ruby@2.7 mysql@5.7 yarn hivemind
brew link --force mysql@5.7
```

3. generate a new SSH key (no password needed):

```
ssh-keygen -t rsa
```

4. copy your public key into the clipboard:

```
pbcopy < ~/.ssh/id_rsa.pub
```

5. sign in to Github and add this SSH key to your account (https://github.com/settings/keys)

6. clone the repo (say yes when asked about the fingerprint):

```
git clone git@github.com:EssentialHealthSolutions/employer-portal.git
```

7. go into the employer-portal directory:

```
cd employer-portal
```

8. add a few environment variables:

```
export PATH="/usr/local/opt/ruby/bin:$PATH"
export TZ="utc"
export SYNC_SECRET_KEY_BASE="cdb2a053479e503de3360cb751f3bedae4588b1f41616ee1dce34e48dc49a84d1d7f6d458e801de46cad0f58f3bab8dfdc6c5dcd501cf24ba6a885f023bf1e32"
export AWS_ACCESS_KEY_ID="AKIAQV6OECHGLZBWFIGK"
export AWS_SECRET_ACCESS_KEY="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"
export S3_PREFIX="dev"
```

9. install ruby dependencies:

```
gem install bundler
bundle
```

10. install javascript dependencies:

```
yarn
```

11. start MySQL:

```
brew services start mysql@5.7
```

12. grant a user for yourself a grant you all privileges (run `whoami` if you don't know your username):

```
sudo mysql
CREATE USER 'yourusername';
GRANT ALL PRIVILEGES ON *.* TO 'yourusername'@'%';
\q
```

13. create the database and generate seeds (if you get error `Unknown database 'employer-portal-dev'` just run the same command a second time):

```
bin/rails prepare
```

14. you should see an output like this:

```
Use "******@example.net" / "******" to sign in as an employer.
Use "******@example.org" / "******" to sign in as an admin user.
```

remember those identifiers as you'll need them to sign in later.

15. add the employer-portal.test domain name to your hostfile:

```
sudo sh -c "echo '127.0.0.1   employer-portal.test' >> /etc/hosts"
```

16. start the webserver:

```
hivemind Procfile.dev
```

17. you can now open your browser (preferably Google Chrome) at http://employer-portal.test:5000 with the employer identifiers or at http://employer-portal.test:5000/admin with the admin user identifiers

If you want to test the integration with the previous database (ecp-dev) you need to setup the Connect Portal (which is outside of the scope of this guide) then add an environment variable like this:

```
SYNC_DATABASE_URL="mysql2://ehsuser:ehsuser@localhost:3306/ecp-dev?charset=utf8&collation=utf8_general_ci"
```

and restart the webserver.

Deployment
==========

We can deploy the app to servers via Capistrano

## Before Deployment

### 1. Setup Server Connection (Local)

1. Go to Bitnami Console to retreive `bitnami-hosting.pem`
2. Place the file under `APP_ROOT/config/deploy/keys/`
3. Change the permission of the file as 600 (`chmod 600 bitnami-hosting.pem`)

### 2. Configure Server (Remote)

Connect server remotely via ssh, and configure the environment

    cap production console  # login remote shell

#### Setup Ruby Environment

    sudo su                            # switch to root
    rvm get stable
    rvm install ruby-2.1

#### Setup PostgreSQL

You should reset password to the role 'bitnami'

    sudo su                            # switch to root
    su - postgres                      # switch to postgres
    /opt/bitnami/postgresql/bin/psql

Then type the password,
which is the application password assigned from bitnami console.

You are in `psql` now:

    ALTER ROLE bitnami with PASSWORD '<new password>' ;
    CREATE DATABASE "nehsaa-mms/production" WITH OWNER bitnami ;

Finally, you can leave `psql` by typing `\q`.

Open `/opt/bitnami/postgresql/data/pg_hba.conf` and change these lines:

    local   all   all                        trust
    host    all   all     127.0.0.1/32       trust
    host    all   all     ::1/128            trust

#### Setup App Folder

    cd /opt/bitnami/apps
    sudo mkdir nehsaa-mms
    sudo chown bitnami: nehsaa-mms

## Setup Configuration Files (Client side)

Create and edit `config/deploy/production/nehsaa.bitnamiapp.com.yml`

    app:
      url_options:
        protocol: https
    database:
      username: bitnami

## Perform Deployment (Client side)

    cap production deploy

## Login Remote SSH Shell

    cap production console

## Login Remote Rails Console

    cap production rails:console

## Manage Remote Application Server

    cap production puma:status
    cap production puma:start
    cap production puma:stop
    cap production puma:restart


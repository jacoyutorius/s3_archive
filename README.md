# S3Archive

指定したディレクトリをtar.gz形式にて圧縮し、S3に世代別バックアップする.	


# Install 

before you need to install AWS CLI.

**install aws cli**

```
chmod 700 install_awscli.sh
./install_awscli.sh
aws configure
```

**install ruby2.3**

```
chmod 700 install_ruby24.sh
./install_ruby24.sh
```


# Usage

```
export AWS_ACCESS_KEY=************
export AWS_ACCESS_SECRET=************
export AWS_REGION=************

s3_archive 3_archive archive target_dir app419
```

## options

#### dry-run

apply --dry option.

```
s3_archive archive . app419 --dry true
```

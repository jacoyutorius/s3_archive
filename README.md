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

#### each

指定したディレクトリ以下のファイルを個別に圧縮しアップロードする.

```
tree ~/Work/vue.js -L 1
/Work/vuejs
├── movie-list
└── vue-component-spa

2 directories, 0 files

# each => false
s3_archive archive /Users/yuto-ogi/Work/vuejs app419 --dry false --each false
# => vuejs.gz がapp419にアップロードされる.	

# each => true
s3_archive archive /Users/yuto-ogi/Work/vuejs app419 --dry false --each true
# => movie-list.gz と vue-component-spa.gz がapp419にアップロードされる.	
```



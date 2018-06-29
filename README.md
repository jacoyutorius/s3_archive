# S3Archive

指定したディレクトリをtar.gz形式にて圧縮し、S3に世代別バックアップする.

## spec

パラメータにて指定されたディレクトリを圧縮し、S3にアップロード。
アップロード完了後、圧縮したファイルを削除する。


**sample**

```
tar -czvf target_dir target_dir.gz
aws s3 cp target_dir.gz s3://target_dir.gz --region ap-northeast-1,
rm -rf target_dir.gz
```

## before install

以下が必要。

- AWS CLI
- Ruby 2.3


## Install

内部的にAWSコマンドを実行しているため、事前にAWS CLIのインストール & クレデンシャル設定が必要。
aws configureを実行するとAWSの認証情報を聞かれるので、access_key, acess_secretを入力する。


**install aws cli**

```
chmod 700 install_awscli.sh
./install_awscli.sh
aws configure
```

**install ruby2.3**

```
chmod 700 install_ruby23.sh
./install_ruby23.sh
ruby -v
```

**install s3_archive**

```bash
cd s3_archive
hmod 700 install.sh
./install.sh
s3_archive version
```

## Usage

```
s3_archive 3_archive archive target_dir app419
```

## options

#### --dry

実行されるコマンドのみ表示する.

```
s3_archive archive . app419 --dry true

# =>
# "[dry-run]  tar -czvf /Work/vuejs.gz /Work/vuejs"
# "[dry-run]  aws s3 cp /Work/vuejs.gz s3://app419/vuejs.gz"
# "[dry-run]  rm -rf /Work/vuejs.gz"
```

#### --each

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
# => movie-list.gz と vue-component-spa.gz がapp419/vuejsにアップロードされる.
```

#### --region

デフォルトは「ap-northeast-1(東京リージョン)」.

```
s3_archive archive /Users/yuto-ogi/Work/vuejs app419 --region us-east-1
```

東京以外のリージョンについては以下を参照。

[リージョンとアベイラビリティーゾーン](http://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

#### --profile

デフォルトは「default」。

**~/.aws/credentials**

```bash
[default]
aws_access_key_id=********************
aws_secret_access_key=****************************************

[s3_admin]
aws_access_key_id=********************
aws_secret_access_key=****************************************

[private]
aws_access_key_id=********************
aws_secret_access_key=****************************************
```

#### --storage_class

デフォルトは「STANDARD_IA」。

[aws s3 cp](https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html)

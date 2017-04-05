# S3Archive

指定したディレクトリをtar形式にて圧縮し、S3に世代別バックアップする.	


# Install 

before you need to install AWS CLI.

```
gem install s3_archive
```


# Usage

```
export AWS_ACCESS_KEY=************
export AWS_ACCESS_SECRET=************
export AWS_REGION=************

s3_archive 3_archive archive target_dir app419
```


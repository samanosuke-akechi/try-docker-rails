# FROM イメージ名:バージョン => イメージはコンテナの土台らしい
FROM ruby:2.7.4

# RUN コマンド => コマンドを実行してミドルウェアをインストール
# apu-get => パッケージの操作・管理を行うコマンド
# build-essentialはLinuxでの開発に必要なビルドツールを提供しているパッケージ
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    nodejs \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /try-docker-rails

# WORKDIR ディレクトリ => 作業ディレクトリの指定
WORKDIR /try-docker-rails

# COPY コピー元 コピー先 => イメージのファイルシステム上に追加したいファイルをコピーする
COPY Gemfile /try-docker-rails/Gemfile
COPY Gemfile.lock /try-docker-rails/Gemfile.lock

RUN gem install bundler
RUN bundle install

# 既存のrailsプロジェクトをコンテナにコピー
COPY . /try-docker-rails

COPY entrypoint.sh /usr/bin/

# コピーしたentrypoint.shの実行権限を全てのユーザーに付与する
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 指定したポートをコンテナがリッスンするリッスンするためのもの(指定のポートで接続して処理する)
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

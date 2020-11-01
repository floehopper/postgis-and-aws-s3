FROM postgis/postgis:11-3.0

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        python2.7 \
        python2.7-dev \
        python-pip \
        git \
        build-essential \
        postgresql-contrib-11 \
        postgresql-plpython-11 \
      && rm -rf /var/lib/apt/lists/*

RUN pip install setuptools

RUN easy_install boto3

RUN git clone https://github.com/chimpler/postgres-aws-s3.git \
      && cd postgres-aws-s3 \
      && pg_config \
      && make install

RUN mkdir -p /docker-entrypoint-initdb.d
# run after 10_postgis.sh
COPY ./initdb-aws-s3.sh /docker-entrypoint-initdb.d/20_aws_s3.sh

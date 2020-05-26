FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
	curl \
	wget \
	zip \
	unzip \
	python3-pip \
	python3-dev \
	python3-setuptools

# awscli 설치
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# kubectl 설치
RUN curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
RUN echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# aws 인증기 설치
RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
RUN echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

# aws 로그인
ARG AWS_KEY={{엑세스키}}
ARG AWS_SECRET_KEY={{시크릿키}}
ARG AWS_REGION={{리전}}
RUN aws configure set aws_access_key_id $AWS_KEY \
	&& aws configure set aws_secret_access_key $AWS_SECRET_KEY \
	&& aws configure set default.region $AWS_REGION

# aws eks configue 세팅
RUN aws eks --region ap-northeast-2 update-kubeconfig --name {{클러스터명}}}

RUN mkdir -p /app

WORKDIR /app

COPY . /app

RUN  pip3 install --upgrade pip
RUN  pip3 install flask
RUN  pip3 install pymysql
RUN  pip3 install requests
RUN  pip3 install boto3
RUN  pip3 install pyyaml

ENV LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED 0

EXPOSE 6000

ENTRYPOINT ["python3", "app.py"]
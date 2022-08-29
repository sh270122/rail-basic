#FROM pa1kilaparthi/ruby:poc_host_cfg
#FROM shiladitya/rubyrails:host
FROM 561866774576.dkr.ecr.us-east-1.amazonaws.com/rail-poc:host
WORKDIR /blog/bin

RUN ls

ENTRYPOINT ["rails", "server", "-b", "0.0.0.0", "-p", "80"]

FROM public.ecr.aws/docker/library/ubuntu:latest
# FROM public.ecr.aws/ubuntu/ubuntu:22.04

RUN apt-get update

RUN apt-get install python3
ARG FUNCTION_DIR="/home/app/"
COPY .  ${FUNCTION_DIR}
RUN mkdir -p ${FUNCTION_DIR}

# Install Lambda Runtime Interface Client for Python
RUN python3 -m pip install awslambdaric --target ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

# (Optional) Add Lambda Runtime Interface Emulator and use a script in the ENTRYPOINT for simpler local runs
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
COPY entry.sh /
RUN chmod 755 /usr/bin/aws-lambda-rie /entry.sh
ENTRYPOINT [ "/entry.sh" ]

CMD [ "app.handler" ]
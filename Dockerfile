FROM node:lts-hydrogen
ENV ROOT=/kikoeru
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y zip
RUN mkdir ${ROOT} && \
    cd ${ROOT} && \
    wget https://github.com/Renari/kikoeru/releases/latest/download/kikoeru.tar.gz && \
    tar xf kikoeru.tar.gz && \
    rm kikoeru.tar.gz && \
    npm i --omit=dev
RUN groupadd -g 568 kikoeru && \
    useradd -m -u 568 -g 568 kikoeru && \
    chown -R kikoeru:kikoeru ${ROOT} && \
    mkdir /data && \
    chown -R kikoeru:kikoeru /data && \
    mkdir /voice && \
    chown -R kikoeru:kikoeru /voice
COPY entrypoint.sh /docker/entrypoint.sh
USER kikoeru
WORKDIR ${ROOT}
EXPOSE 8888
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD ["npm", "run", "start"]

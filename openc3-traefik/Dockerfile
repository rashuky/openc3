ARG OPENC3_REGISTRY=docker.io
FROM ${OPENC3_REGISTRY}/traefik:2.8.3
COPY cacert.pem /devel/cacert.pem
ENV SSL_CERT_FILE=/devel/cacert.pem
ENV CURL_CA_BUNDLE=/devel/cacert.pem
ENV REQUESTS_CA_BUNDLE=/devel/cacert.pem
ENV NODE_EXTRA_CA_CERTS=/devel/cacert.pem
COPY ./traefik.yaml /etc/traefik/traefik.yaml
EXPOSE 80

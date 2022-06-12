FROM alpine

# EXPOSE 7545

COPY ./ /eth
WORKDIR /eth
RUN apk --no-cache add yarn git
RUN yarn install \
    && ./node_modules/.bin/truffle compile
WORKDIR /eth
CMD [ "./node_modules/.bin/truffle", "migrate" ]

# You need to run ethereum vm, e.g.
# docker run --net=host ethereum/client-go --dev --http --http.port 7545 --http.api eth,web3,personal,net --http.corsdomain http://remix.ethereum.org

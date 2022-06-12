FROM alpine

COPY ./ /eth
WORKDIR /eth
RUN apk --no-cache add yarn git
RUN yarn install \
    && ./node_modules/.bin/truffle compile
WORKDIR /eth
CMD [ "./node_modules/.bin/truffle", "migrate" ]
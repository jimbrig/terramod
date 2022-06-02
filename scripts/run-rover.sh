#!/usr/bin/env bash

cd ..

# docker run --rm -it -p 9000:9000 --env-file ../.env -v $(pwd)../:/src im2nguyen/rover -standalone true
docker run --rm -it -p 9000:9000 --env-file .env -v $(pwd):/src im2nguyen/rover

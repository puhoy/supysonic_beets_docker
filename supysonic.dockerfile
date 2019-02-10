FROM arm64v8/python:3.7.2-alpine3.9
#FROM python:3.7.2-alpine3.9

WORKDIR /task

RUN apk add --no-cache git zlib-dev zlib alpine-sdk libjpeg-turbo-dev postgresql-dev ffmpeg ffmpeg-dev \
cmake \
build-base gcc abuild binutils binutils-doc gcc-doc

RUN git clone https://github.com/acoustid/chromaprint.git
RUN cd chromaprint && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOLS=ON . && make && make install

RUN pip install gunicorn psycopg2-binary pyacoustid discogs_client

RUN git clone https://github.com/beetbox/beets.git && cd beets && pip install .

RUN git clone https://github.com/spl0k/supysonic.git && cd supysonic && pip install . && pip install .[watcher]
COPY supysonic.conf /etc/supysonic
COPY start.sh /task/start.sh
COPY wait-for /task/wait-for

CMD /task/start.sh

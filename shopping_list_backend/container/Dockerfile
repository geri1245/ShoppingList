FROM ubuntu

WORKDIR /app

EXPOSE 3000

COPY ./resources/server /bin/
COPY ./resources/my_db.sqlite3 ./
COPY ./main.bash /app/

RUN ["chmod", "+x", "/app/main.bash"]

ENTRYPOINT ["/app/main.bash"]
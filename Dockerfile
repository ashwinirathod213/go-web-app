#build from offical image of golang and create an alias
FROM golang:1.23 as base 

#set a working directory
WORKDIR /app

#copy dependencies of application
COPY go.mod .

#running dependcies for go application
RUN go mod download

#copying source code into docker image
COPY . .

#run command to build appplication
RUN go build -o main .

#Final stage - distroless image
FROM gcr.io/distroless/base

#copying build from first stage
COPY --from=base /app/main .

#copy static content
COPY --from=base /app/static ./static

#expose to port 8080
EXPOSE 8080

#run the application
CMD [ "./main" ]

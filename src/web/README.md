# fresh project

### Usage

Start the project:

```
deno task start
```

This will watch the project directory and restart as necessary.


### Docker 
```
docker build -t sjkp/deno-azd-template . && docker run -it -p 8091:3001 sjkp/deno-azd-template
```
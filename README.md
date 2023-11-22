# excalidraw-collaboration

One click to init an excalidraw with collaboration.

Snapshot:

![snapshot](./_assets/snapshot.png)

Demo:

[Live Demo](https://draw2.dmitrysamoylenko.in/)
A live room sample here: [live room](https://draw2.dmitrysamoylenko.in/#room=f8671f3fdef3ada5128c,Dyn8aqg8RII9rzUVIl9i7w)

Thanks a lot to @samoylenkodmitry.

Related docs:

- [Self hosted online collaborative drawing platform Excalidraw | Log4D](https://en.blog.alswl.com/2022/10/self-hosted-excalidraw/)
- [私有化在线协同画图平台 Excalidraw | Log4D]( https://blog.alswl.com/2022/10/self-hosted-excalidraw/ )


## Deploy

Clone, and run:

```
git clone git@github.com:alswl/excalidraw-collaboration.git
cd excalidraw-collaboration

docker-compose up # run the containers

open "http://localhost" # open browser, and you can using the collbration functions
```

Browse it:

- open http://127.0.0.1/ ,and you will see the excalidraw page
- Click the `Live Collaboration` button, and you will see the collaboration page
- Now you can share the collaboration page with your friends, and you can draw together.


About public network release:

if you want to release your own excalidraw in public network,
you should modify the `docker-compose.yaml` file,
Replace the `REACT_APP_HTTP_STORAGE_BACKEND_URL` and `REACT_APP_WS_SERVER_URL` with your own domain.

## Roadmap

- [x] collaboration feature works
- [x] No pre-build image, dynamic env
- [x] Upload Docker Hub image
- [ ] S3 storage support
- [ ] SSO support
- [ ] HTTPS Demo and docs
- [ ] Helm support
- [x] Online demo
- [ ] One click to deploy somewhere

## Q & A

### How to deploy on the cloud(aws etc)

The `docker-compose.yaml` file is for local deploy, if you want to deploy on the cloud,
you should prepare 2 Load Balancer(with HTTPS cert), one for websocket server, one for storage server.

The `REACT_APP_HTTP_STORAGE_BACKEND_URL` is for the Load Balancer URL(HTTPS) for storage,
and the `REACT_APP_WS_SERVER_URL` is for the Load Balancer URL(HTTPS) for websocket.

Here is a conversation about how to deploy on the aws: https://github.com/alswl/excalidraw-collaboration/issues/22

### generateKey problem

Error message:

```
TypeError: Cannot read properties of undefined (reading 'generateKey')
```

Why: The excalidraw is using crypto module of Javascript, the HTTPS is required.

How to solve: use HTTPS to access the page, or use http://localhost instead.



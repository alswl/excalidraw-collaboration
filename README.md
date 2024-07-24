# excalidraw-collaboration

Demo:

[demo](https://excalidraw-production-4d27.up.railway.app/) on [Railway](https://railway.app?referralCode=HM_ZCO)

One click to deploy your excalidraw with collaboration.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/PjQnHs?referralCode=HM_ZCO)

Snapshot:

![snapshot](./_assets/snapshot.png)

Related docs:

- [Self hosted online collaborative drawing platform Excalidraw | Log4D](https://en.blog.alswl.com/2022/10/self-hosted-excalidraw/)
- [私有化在线协同画图平台 Excalidraw | Log4D](https://blog.alswl.com/2022/10/self-hosted-excalidraw/)

## Deploy (Basic)

Clone, and run:

```
git clone git@github.com:alswl/excalidraw-collaboration.git
cd excalidraw-collaboration/basic

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
Replace the `VITE_APP_HTTP_STORAGE_BACKEND_URL` and `VITE_APP_WS_SERVER_URL` with your own domain.

## Advanced mode

### advanced-nginx

Features:

- Setup with one domain, and use nginx to proxy the requests to the backend services
- HTTPS support

## Roadmap

- [x] self-host
- [x] collaboration feature works
- [x] docker-compose support
- [x] no pre-build image, dynamic env
- [x] upload Docker Hub image
- [ ] S3 storage support
- [ ] SSO support
- [x] HTTPS Demo and
- [x] HTTPS docs
- [ ] Helm support
- [x] online demo
- [x] one click to deploy Railway

## Upgrade Guide

- v0.15.0 -> v0.16.1
  - replace `REACT_APP_` env with `VITE_APP_`

## Q & A

### How to deploy on the cloud(aws etc)

The `docker-compose.yaml` file is for local deploy, if you want to deploy on the cloud,
you should prepare 2 Load Balancer(with HTTPS cert), one for websocket server, one for storage server.

The `VITE_APP_HTTP_STORAGE_BACKEND_URL` is for the Load Balancer URL(HTTPS) for storage,
and the `VITE_APP_WS_SERVER_URL` is for the Load Balancer URL(HTTPS) for websocket.

Here is a conversation about how to deploy on the aws: https://github.com/alswl/excalidraw-collaboration/issues/22

### generateKey problem

Error message:

```
TypeError: Cannot read properties of undefined (reading 'generateKey')
```

Why: The excalidraw is using crypto module of Javascript, the HTTPS is required.

How to solve: use HTTPS to access the page, or use http://localhost instead.

## Contributors

<a href="https://github.com/alswl/excalidraw-collaboration/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=alswl/excalidraw-collaboration" />
</a>

# excalidraw-collaboration

One click to init an excalidraw with collaboration.

Docs:

- [Self hosted online collaborative drawing platform Excalidraw | Log4D](https://en.blog.alswl.com/2022/10/self-hosted-excalidraw/)
- [私有化在线协同画图平台 Excalidraw | Log4D]( https://blog.alswl.com/2022/10/self-hosted-excalidraw/ )

Build and Run:

```
git config submodule.excalidraw.ignore all # ignore submodule changes, we will patch them

make patch
make images
make bump-version
docker-compose up
```

Browse:

- open http://127.0.0.1/ ,and you will see the excalidraw page
- Click the `Live Collaboration` button, and you will see the collaboration page
- Now you can share the collaboration page with your friends, and you can draw together.


Public Release:

if you want to release your own excalidraw in public network,
you should modify the `excalidraw.production.env` file,
Replace the `REACT_APP_HTTP_STORAGE_BACKEND_URL` and `REACT_APP_WS_SERVER_URL` with your own domain.